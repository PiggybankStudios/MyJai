
#import "Basic";
#import "Math";

vector_tests :: ()
{
	printline("Vector tests...");
	size := v2.{ 12, 28.5 };
	printline("size = %", size);
	printline("size.width = % size.height = %", size.width, size.height);
}

main :: ()
{
	printline("\nRunning tests...\n");
	vector_tests();
	printline("\nFinished tests");
}

#run main();
