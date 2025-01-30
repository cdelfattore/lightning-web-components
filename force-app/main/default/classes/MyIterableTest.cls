@IsTest
private class MyIterableTest
{
    @IsTest
    private static void testIterableForLoop()
    {
        List<String> strings = new List<String> {'Hello', 'World'};
        MyIterable myIt = new MyIterable(strings);
        for (String s : myIt)
        {
            System.debug(s);
        }
    }
}