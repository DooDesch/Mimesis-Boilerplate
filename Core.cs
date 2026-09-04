using Boilerplate.Config;
using MelonLoader;

[assembly: MelonInfo(typeof(Boilerplate.Core), "Boilerplate", DooDesch.ModVersion.Current, "DooDesch", null)]
[assembly: MelonGame("ReLUGames", "MIMESIS")]
// Uncomment if using MimicAPI
// [assembly: MelonOptionalDependencies("MimicAPI")]

namespace Boilerplate
{
	public sealed class Core : MelonMod
	{
		public override void OnInitializeMelon()
		{
			BoilerplatePreferences.Initialize();
			// MelonLoader auto-applies this assembly's Harmony patches via HarmonyInit(); calling PatchAll()
			// here too would double-apply every patch (each prefix/postfix runs twice). Do NOT add it back.
			// (See FakePlayers/Core.cs.)
			MelonLogger.Msg("Boilerplate initialized. Enabled={0}", BoilerplatePreferences.Enabled);
		}
	}
}

