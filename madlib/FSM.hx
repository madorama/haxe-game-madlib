package madlib;

import haxe.ds.Option;

using madlib.extensions.ArrayExt;
using madlib.extensions.OptionExt;
using thx.Maps;

abstract class StateBase<T> {
    public function new() {}

    public function update(owner: T, dt: Float) {}

    public function enter(owner: T) {}

    public function exit(owner: T) {}
}

private typedef StateClass<T> = Class<StateBase<T>>;

class FSM<T> {
    public var owner(default, null): T;

    public var transitions(default, null): FSMTransitionTable<T> = new FSMTransitionTable();

    var stateClass: Option<StateClass<T>> = None;

    var state: Option<StateBase<T>> = None;

    final states = new Map<String, StateBase<T>>();

    public function new(owner: T, ?defaultState: StateBase<T>) {
        this.owner = owner;
        if(defaultState != null)
            setState(defaultState);
    }

    public inline function forceChangeState(state: StateBase<T>) {
        this.state = Some(state);
        stateClass = Some(Type.getClass(state));
    }

    public function setState(state: StateBase<T>) {
        final newClass = Type.getClass(state);
        if(!this.stateClass.contains(newClass)) {
            this.state.each(s -> s.exit(owner));
            forceChangeState(state);
            this.state.each(s -> s.enter(owner));
        }
    }

    public inline function update(dt: Float) {
        state.each(s -> s.update(owner, dt));
        transition();
    }

    public inline function transition() {
        switch transitions.poll(stateClass, owner) {
            case None:
            case Some(newStateClass):
                if(stateClass.contains(newStateClass))
                    return;
                final currentClassName = stateClass.map(Type.getClassName).withDefault("");
                final newClassName = Type.getClassName(newStateClass);
                final oldState = state;
                setState(states.getAltSet(newClassName, Type.createInstance(newStateClass, [])));
                switch oldState {
                    case None:
                    case Some(v):
                        if(states.exists(currentClassName))
                            states.set(currentClassName, v);
                }
        }
    }

    public inline function changeOwner(owner: T) {
        if(this.owner != owner) {
            state.each(c -> c.exit(this.owner));
            this.owner = owner;
            state.each(c -> c.enter(this.owner));
        }
        return this.owner;
    }
}

@:structInit
class Transition<T> {
    public var from: Option<StateClass<T>> = None;
    public var to: StateClass<T>;
    public var condition: T -> Bool;

    public function new(to: StateClass<T>, condition: T -> Bool) {
        this.to = to;
        this.condition = condition;
    }
}

private class FSMTransitionTable<T> {
    final table: Array<Transition<T>> = [];
    var startState: Option<StateClass<T>> = None;

    public function new() {}

    public inline function add(from: StateClass<T>, to: StateClass<T>, condition: T -> Bool): FSMTransitionTable<T> {
        if(!hasTransition(from, to, condition)) {
            final transition = new Transition(to, condition);
            transition.from = Some(from);
            table.push(transition);
        }
        return this;
    }

    public inline function addTransition(transition: Transition<T>) {
        if(!table.contains(transition))
            table.push(transition);
    }

    public inline function start(with: StateClass<T>): FSMTransitionTable<T> {
        startState = Some(with);
        return this;
    }

    inline function hasTransition(from: StateClass<T>, to: StateClass<T>, condition: T -> Bool): Bool
        return table.any(t -> t.from.contains(from) && t.to == to && t.condition == t.condition);

    public function poll(currentState: Option<StateClass<T>>, owner: T): Option<StateClass<T>> {
        if(currentState.isNone()) {
            switch startState {
                case Some(v):
                    return Some(v);
                case None:
            }
        }

        for(t in table) {
            if(t.from.equals(currentState) || t.from.isNone()) {
                if(t.condition(owner))
                    return Some(t.to);
            }
        }

        return None;
    }
}
