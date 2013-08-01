package org.aijai.statemachine;

/**
 * A collection of states.
 * @author Pekka Heikkinen
 */
class MultiState<T> implements IStateMachine
{
	
	private var stateList:Array<IState<T>>;
	private var owner:T;
	
	public function new(Owner:T) 
	{
		this.owner = Owner;
		reset();
	}
	
	/**
	 * Calls the exit function on each state and clears the list
	 */
	public function reset():Void
	{
		if (stateList != null)
		{
			for (st in stateList)
			{
				st.exit(owner);
			}
		}
		stateList = new Array<IState<T>>();
	}
	
	/**
	 * Creates an instance of class
	 * @param	Cl
	 * @return
	 */
	private function getInstance(Cl:Class<IState<T>>):IState<T>
	{
		return Type.createInstance(Cl, []);
	}
	
	/**
	 * Cleanup after state is removed from list
	 * @param	Object
	 */
	private function releaseInstance(Object:IState<T>):Void
	{
		
	}
	
	public function get(Cl:Class<IState<T>>):IState<T>
	{
		for (st in stateList)
		{
			if (Type.getClass(st) == Cl)
			{
				return st;
			}
		}
		return null;
	}
	
	/**
	 * Adds a class that implements IState
	 * @param	State
	 * @return	Class instance
	 */
	public function add(State:Class<IState<T>>):IState<T>
	{
		var StateInstance = getInstance(State);
		return addInstance(StateInstance);
	}
	
	/**
	 * Check if contains an instance of class
	 * @param	State
	 * @return
	 */
	public function has(State:Class<IState<T>>):Bool
	{
		for (st in stateList)
		{
			// Don't add twice
			if (Type.getClass(st) == State)
			{
				return true;
			}
		}
		return false;
	}
	
	public function addInstance(StateInstance:IState<T>):IState<T>
	{
		stateList.push(StateInstance);
		StateInstance.enter(owner);
		return StateInstance;
	}
	
	public function removeInstance(StateInstance:IState<T>):List<IState<T>>
	{
		var stateClass = Type.getClass(StateInstance);
		return remove(stateClass);
	}
	
	public function remove(State:Class<IState<T>>):List<IState<T>>
	{
		var l:List<IState<T>> = new List<IState<T>>();
		var rem:IState<T> = null;
		for (st in stateList)
		{
			if (Type.getClass(st) == State)
			{
				st.exit(owner);
				l.push(st);
				rem = st;
			}
		}
		for (st in l)
		{
			stateList.remove(st);
			releaseInstance(st);
		}
		return l;
	}
	
	public function replace(OriginalState:Class<IState<T>>, NewState:Class<IState<T>>):Void
	{
		var replaced:IState<T>;
		for (i in 0...stateList.length)
		{
			if (Type.getClass(stateList[i]) == OriginalState)
			{
				stateList[i].exit(owner);
				releaseInstance(stateList[i]);
				stateList[i] = getInstance(NewState);
				stateList[i].enter(owner);
				break;
			}
		}
	}
	
	/**
	 * Execute every state
	 */
	public function execute():Void
	{
		for (st in stateList)
		{
			st.execute(owner);
		}
	}
	
}