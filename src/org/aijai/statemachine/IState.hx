package org.aijai.statemachine;

/**
 * ...
 * @author Pekka Heikkinen
 */

interface IState<T>
{
	function enter(Owner:T):Void;
	function execute(Owner:T):Void;
	function exit(Owner:T):Void;
}