package madlib.error;

import haxe.PosInfos;

class NotImplemented extends haxe.Exception {
    public function new(?posInfo: PosInfos)
        super('method ${posInfo.className}.${posInfo.methodName}() needs to be implemented', posInfo);
}
