require 'despeck/installation_check'
exit(1) unless Despeck::InstallationCheck.pre_install_valid?