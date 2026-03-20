
#import "Basic";
#import "Math";

vector_tests :: ()
{
	printline("Vector tests...");
	size1 := v2.{ 12, 28.5 };
	size2 := v2.{ 4.345, 3.5 };
	printline("size1 = % or (%, %)", size1, size1.width, size1.height);
	printline("size2 = % or (%, %)", size2, size2.width, size2.height);
	printline("size1+size2 = %", size1 + size2);
	printline("size1-size2 = %", size1 - size2);
	printline("size1*size2 = %", size1 * size2);
	printline("size1/size2 = %", size1 / size2);
	printline("size1==size2 = %", size1 == size2);
	printline("size1!=size2 = %", size1 != size2);
	
	printline("");
	
	sizei1 := v2i.{ 12, -28 };
	sizei2 := v2i.{ -4, 32 };
	scalari : s32 = 2;
	printline("sizei1 = % or (%, %)", sizei1, sizei1.width, sizei1.height);
	printline("sizei2 = % or (%, %)", sizei2, sizei2.width, sizei2.height);
	printline("scalari = %", scalari);
	printline("sizei1+sizei2 = %", sizei1 + sizei2);
	printline("sizei1-sizei2 = %", sizei1 - sizei2);
	printline("sizei1*sizei2 = %", sizei1 * sizei2);
	printline("sizei1*scalari = %", sizei1 * scalari);
	printline("sizei1/sizei2 = %", sizei1 / sizei2);
	printline("sizei1/scalari = %", sizei1 / scalari);
	printline("sizei1==sizei2 = %", sizei1 == sizei2);
	printline("sizei1!=sizei2 = %", sizei1 != sizei2);
}

main :: ()
{
	printline("\nRunning tests...\n");
	vector_tests();
	printline("\nFinished tests");
}
