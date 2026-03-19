/*
File:   build.jai
Author: Taylor Robbins
Date:   03\17\2026
Description: 
	** The single script for building all projects in this repository
*/

#import "Basic";
#import "Compiler";
#import "String";
#import "File";
#import "File_Utilities";
#import "Process";

// +--------------------------------------------------------------+
// |                 Build Configuration Options                  |
// +--------------------------------------------------------------+
DEBUG_BUILD :: true;

BUILD_WINDOWS :: false;
BUILD_LINUX   :: true;
BUILD_OSX     :: false;

My_Jai_Targets :: enum
{
	PLAYGROUND;
	TESTS;
	COUNT;
}
JaiTargetInfo :: struct
{
	build : bool;
	run: bool;
	path: string;
	exe_name: string;
};

BUILD_PLAYGROUND :: true;
RUN_PLAYGROUND   :: true;

BUILD_TESTS :: true;
RUN_TESTS   :: true;


SHOW_BUILD_TIME :: false;
SHOW_LINK_LINE  :: false;

// +--------------------------------------------------------------+
// |                         Build Script                         |
// +--------------------------------------------------------------+
build :: ()
{
	printline("Building...");
	TARGETS : [2]JaiTargetInfo = .[
		{ BUILD_PLAYGROUND, RUN_PLAYGROUND, "playground/main.jai", "playground" },
		{ BUILD_TESTS, RUN_TESTS, "tests/main.jai", "tests" },
	];
	BUILD_ON_OS : [13]bool; //TODO(robbitay): How do we get count of enum values at compile time?
	BUILD_ON_OS[Operating_System_Tag.WINDOWS] = BUILD_WINDOWS;
	BUILD_ON_OS[Operating_System_Tag.LINUX] = BUILD_LINUX;
	BUILD_ON_OS[Operating_System_Tag.MACOS] = BUILD_OSX;
	
	for target: enum_values_as_enum(My_Jai_Targets)
	{
		if (target < My_Jai_Targets.COUNT && TARGETS[target].build)
		{
			for targetOS: enum_values_as_enum(Operating_System_Tag)
			{
				if (BUILD_ON_OS[targetOS])
				{
					printline("Building % for %%...", target, targetOS, ifx DEBUG_BUILD then " (DEBUG)" else "");
					ws : Workspace = compiler_create_workspace(sprint("% Workspace (%)", target, targetOS));
					
					wsOps : Build_Options = get_build_options(ws);
					{
						wsOps.os_target = targetOS;
						if (targetOS == OS)
						{
							wsOps.output_path = "build";
							wsOps.intermediate_path = "build";
							wsOps.output_type = .EXECUTABLE;
						}
						else
						{
							wsOps.output_path = sprint("build/%", targetOS);
							wsOps.intermediate_path = sprint("build/%", targetOS);
							wsOps.output_type = .OBJECT_FILE; //TODO: It seems we can't actually link a binary executable for other platforms currently?
						}
						wsOps.output_executable_name = TARGETS[target].exe_name;
						wsOps.backend = ifx DEBUG_BUILD then .X64 else .LLVM;
						set_optimization(*wsOps, ifx DEBUG_BUILD then .DEBUG else .OPTIMIZED);
						wsOps.dead_code_elimination = .NONE;
						wsOps.text_output_flags = 0;
						if (SHOW_LINK_LINE) { wsOps.text_output_flags |= .OUTPUT_LINK_LINE; }
						if (SHOW_BUILD_TIME) { wsOps.text_output_flags |= .OUTPUT_TIMING_INFO; }
						importDirs : [..]string;
						array_add(*importDirs, "core/");
						for wsOps.import_path { array_add(*importDirs, it); }
						wsOps.import_path = importDirs;
					}
					set_build_options(wsOps, ws);
					
					add_build_file(TARGETS[target].path, ws);
					
					if (TARGETS[target].run && targetOS == OS)
					{
						//TODO(robbitay): Implement me!
					}
				}
			}
		}
	}
	
	set_build_options_dc(.{do_output=false, write_added_strings=false});
}

#run build();
