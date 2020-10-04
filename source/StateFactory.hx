package;

class StateFactory
{
	static var cont: StateContainer;

	public static function getState()
	{
		if (cont == null)
		{
			cont = new StateContainer();
		}

		return cont;
	}

	public static function resetState() {
		cont = new StateContainer();
	}
}
