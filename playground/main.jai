
#import "Basic";
#import "DebugOutput" (DEBUG_OUTPUT_ENABLED=true);
#import "Math";
#import "Window_Creation";
#import "Input";
#import "Process";
GetRect :: #import "GetRect_LeftHanded";
Simp :: #import "Simp";

my_window: Window_Type;
window_width: s32 = 480;
window_height: s32 = 240;

current_time: float64;
last_time:    float64;
current_dt:   float;
cursor_pos: Vector2;

main :: ()
{
	printline("Hello from Jai! (PLAYGROUND)");
	
	#if (OS == .WINDOWS)
	{
		Windows :: #import "Windows";
		Windows.SetProcessDPIAware();
		// Windows is very bad at thread-switching by default unless you do this. Sad.
		Windows.timeBeginPeriod(1);
	}
	
	my_window = create_window(window_width, window_height, "A Window");
	#if (OS == .WINDOWS)
	{
		// @Feature: Add user-specific typelist support.
		Windows.DragAcceptFiles(my_window, cast(Windows.BOOL) true);
	}
	else #if (OS == .LINUX)
	{
		X11 :: #import "X11";
		typelist := string.["url/url", "text/uri-list", "text/plain", "application/octet-stream"];
		X11.enable_drag_and_drop(my_window, typelist);
	}
	else #if (OS == .MACOS)
	{
		#import "Objective_C";
		#import "Objective_C/AppKit";
		types := NSArray(NSPasteboardType).arrayWithObject(NSPasteboardTypeFileURL);
		NSView.registerForDraggedTypes(my_window, types);
	}
	
	Simp.set_render_target(my_window, .LEFT_HANDED);
	
	GetRect.ui_init();
	
	quit := false;
	while (!quit)
	{
		at := current_time_monotonic();
		current_time = to_float64_seconds(at);
		dt := cast(float)(current_time - last_time);
		Clamp(*dt, 0, 0.1);
		current_dt = dt;
		last_time = current_time;
		update_window_events();
		
		for get_window_resizes()
		{
			Simp.update_window(it.window);
			if (it.window == my_window)
			{
				size_changed := (it.width != window_width) || (it.height != window_height);
				window_width  = it.width;
				window_height = it.height;
			}
		}
		
		for event: events_this_frame
		{
			if (event.type == .QUIT) { quit = true; }
			
			GetRect.getrect_handle_event(event);
			
			if event.type == {
				case .KEYBOARD;
					if event.key_code == {
					    case .ESCAPE; if (event.key_pressed) { quit = true; }
					}
				case .DRAG_AND_DROP_FILES;
					for event.files
					{
						printline_i("Dropped file \"%\"", it);
					}
			}
		}
		
		draw_one_frame(dt);
		reset_temporary_storage();
		sleep_milliseconds(10);
	}
}

draw_one_frame :: (dt: float) {
	Simp.clear_render_target(.15, .11, .11, 1);
	
	x, y, width, height := get_dimensions(my_window, true);
	background_occluded := GetRect.ui_per_frame_update(my_window, width, height, current_time);
	
	screen := GetRect.get_rect(0, 0, xx window_width, xx window_height);
	sidebar_width := window_height / 15.0;
	sidebar, content_rect := GetRect.cut_left(screen, sidebar_width);
	update_cursor_pos();
	
	button_margin_x :: 0.05;
	button_margin_y :: 0.25;
	button_aspect_ratio :: 4 / 1;
	label_theme: GetRect.Label_Theme;
	label_theme.alignment = .Center;
	middle := GetRect.shrink_y(GetRect.shrink_x(content_rect, content_rect.w*button_margin_x), content_rect.h*button_margin_y);
	max_height := (middle.w / button_aspect_ratio);
	if (middle.h > max_height)
	{
		middle.y = middle.y + (middle.h - max_height)/2;
		middle.h = max_height;
	}
	// GetRect.label(middle, "Hello World!", *label_theme);
	if (GetRect.button(middle, "Hello World!"))
	{
		writeline_w("Hello World!");
	}
	
	GetRect.draw_popups();  // This draws Subwindows as well.
	
	Simp.swap_buffers(my_window);
}

update_cursor_pos :: ()
{
	x, y := get_mouse_pointer_position(my_window, false);
	cursor_pos.x = cast(float) x;
	cursor_pos.y = cast(float) y;
}
