package tests;

import utest.Runner;
import utest.ui.Report;

class MadlibTests {
    public static function main() {
        final tests = [
            new TestProperty(),
            new TestVersion(),
            new TestUtil(),
            new TestNullExt(),
            new TestOptionExt(),
            new TestIteratorExt(),
            new TestArrayExt(),
        ];
        final runner = new Runner();
        for(test in tests)
            runner.addCase(test);

        new utest.ui.text.DiagnosticsReport(runner);
        runner.run();
    }
}
