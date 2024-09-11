Context {
    User "qwreey" {
        Package :Handle(nimf) {
            nimf.ActionOrProp "something";
        };
    };

    System {
        Group "PkgGroupName" {
            Package :Name("DisplayPackageName") "linux";
        };
    };
}:Compile():Write("./install.sh")
