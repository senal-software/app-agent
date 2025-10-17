{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
  ];

  # https://devenv.sh/languages/
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_22;
    npm = {
      enable = true;
    };
  };

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_15;
    listen_addresses = "127.0.0.1";
    port = 5432;
    initialDatabases = [
      { name = "aso"; }
    ];
    initialScript = ''
      CREATE USER aso_user WITH PASSWORD 'aso_password';
      GRANT ALL PRIVILEGES ON DATABASE aso TO aso_user;
      \c aso
      GRANT ALL ON SCHEMA public TO aso_user;
      ALTER SCHEMA public OWNER TO aso_user;
    '';
  };

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    echo "Node.js $(node --version)"
    echo "npm $(npm --version)"
    git --version
    echo "PostgreSQL available on port 5432"
    echo "Database: aso"
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
