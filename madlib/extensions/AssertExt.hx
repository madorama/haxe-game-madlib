package madlib.extensions;

#if test
import haxe.PosInfos;
import utest.Assert;

@:access(utest.Assert)
class AssertExt {
    @:nullSafety(Off)
    public static function notSame(expected: Dynamic, value: Dynamic, ?recursive: Bool, ?msg: String, ?approx: Float, ?pos: PosInfos): Bool {
        if(approx == null)
            approx = 1e-5;
        var status = {
            recursive: if(recursive == null) true else recursive,
            path: '',
            error: null,
            expectedValue: expected,
            actualValue: value
        };
        return if(Assert.sameAs(expected, value, status, approx)) {
            Assert.fail(msg == null ? status.error : msg, pos);
        } else {
            Assert.pass(msg, pos);
        }
    }
}
#end
