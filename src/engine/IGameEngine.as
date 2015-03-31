package engine 
{
	
	/**
	 * ...
	 * @author Bagish M.
	 */
	public interface IGameEngine 
	{
		function get gameField():Vector.<Vector.<Cell>>;
		function get nextShapeIndex():int;
		function get level():int;
		function get score():int;
		function get linesCleared():int;
	}
	
}