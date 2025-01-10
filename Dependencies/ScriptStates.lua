--!nolint UnknownGlobal
local State = {}

State.data = {
	Games = {
		["76455837887178"] = { -- // Dig It
			Shutdown = {
				Status = false,
				Reason = 'shutdown'
			},
			KeySystem = true,
			Script = ""
		}
	},
	KeySystemProviders = {
		{
			Title = "Linkvertise\n(12 hours)",
			Callback = function(Base)
				setclipboard("")
				Base:Notification("key system link is now in your clipboard!\npaste it in your browser to continue")
			end,
		},
		{
			Title = "ShrinkEarn\n(8 hours)",
			Callback = function(Base)
				setclipboard("")
				Base:Notification("key system link is now in your clipboard!\npaste it in your browser to continue")
			end,
		}
	}
}

return State
