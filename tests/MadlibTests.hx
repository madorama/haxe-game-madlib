package tests;

import tests.TestTuple;
import utest.Runner;
import utest.ui.Report;

class MadlibTests {
    public static function main() {
        final tests = [
            new TestProperty(),
            new TestVersion(),
            new TestPaginate(),
            new TestUtil(),
            new TestNullExt(),
            new TestTuple1(),
            new TestTuple2(),
            new TestTuple3(),
            new TestOptionExt(),
            new TestIteratorExt(),
            new TestArrayExt(),
            new TestFunctionExt(),
            new TestStringExt(),
        ];
        final runner = new Runner();
        for(test in tests)
            runner.addCase(test);

        new utest.ui.text.DiagnosticsReport(runner);
        runner.run();
    }
}
