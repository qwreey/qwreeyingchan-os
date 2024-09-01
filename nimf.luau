return Handle {

    Package 'qwreeyingchan/nimf-libhangul-git';

    TargetUser = Prop(TString):Handle(function(handle)
        handle.HandleShared.TargetUser = {}
        handle.OnData = function(data)
            table.insert(handle.HandleShared.TargetUser,data)
        end
    end);

    HotKeys = Prop(TString):Handle(function(handle)
        local HotKeys = {}
        handle.OnData = function(data)
            table.insert(HotKeys,("'%s'"):format(handle.HandleShared.HotKeys))
        end
        handle.OnDataEnd = function()
            handle.HandleShared.HotKeys = table.concat(HotKeys,",")
        end
    end);

    AfterInstall(function(Package,HandleShared)
        for _,user in ipairs(HandleShared.TargetUser) do
            Package:AddAction(
                Dconf :As(user) [[
                    [org/nimf]
                    hidden-active-engines=['nimf-libhangul', 'nimf-system-keyboard']
                    hotkeys=[]](HandleShared.HotKeys)[[]
                    setup-environment-variables=false

                    [org/nimf/engines/nimf-libhangul]
                    hanja-keys=@as []
                    shortcuts-to-lang=['<Mod4> Shift_L']
                    shortcuts-to-sys=['<Mod4> Shift_L']

                    [org/nimf/engines/nimf-m17n-vi]
                    active-engine=false

                    [org/nimf/engines/nimf-rime]
                    active-engine=false
                ]] :StripIndent()
            )
        end
    end);

}