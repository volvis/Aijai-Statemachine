package org.aijai.statemachine;

/**
 * Basic state machine implementation
 * @author Pekka Heikkinen
 */

class StateMachine<T> implements IStateMachine
{
	private var owner:T;
	private var currentState:IState<T>;
	private var previousState:IState<T>;
	private var hasState:Bool;
	private var lock:Bool;
	
	public function new(Owner:T) 
	{
		this.owner = Owner;
		hasState = false;
		lock = false;
	}
	
	/**
	 * Checks if class is the current state
	 * @param	c	
	 */
	public function currently(c:Class<IState<T>>):Bool {
		return (Type.getClass(currentState) == c);
	}
	
	/**
	 * Checks if class was the previous state
	 * @param	c
	 */
	public function previously(c:Class<IState<T>>):Bool {
		if (previousState != null) {
			return (Type.getClass(previousState) == c);
		}
		return false;
	}
	
	/**
	 * Changes the state for the statemachine
	 * @param	State	IState object
	 * @param	?Force	Ignore if another state has been already set.
	 */
	public function changeState(State:IState<T>, Force:Bool = false):Void
	{
		if (lock && !Force) return;
		if (currentState != null) {
			currentState.exit(owner);
			previousState = currentState;
		}
		currentState = State;
		currentState.enter(owner);
		lock = true;
	}
	
	/**
	 * Executes the currently active state
	 */
	public function execute():Void
	{
		if (currentState == null) return;
		lock = false;
		currentState.execute(owner);
	}
}