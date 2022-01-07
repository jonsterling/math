# Reference: https://www.tug.org/texlive/doc/install-tl.html#PROFILES

#=[ Scheme ]====================================================================
# selected_scheme scheme-infraonly
selected_scheme scheme-small

#=[ Collections ]===============================================================
# No collections.

#=[ Paths ]=====================================================================
# These are the expected defaults in portable mode
# TEXDIR $TEXLIVE_INSTALL_PREFIX
# TEXMFLOCAL $TEXLIVE_INSTALL_PREFIX/texmf-local
# TEXMFSYSVAR $TEXLIVE_INSTALL_PREFIX/texmf-var
# TEXMFSYSCONFIG $TEXLIVE_INSTALL_PREFIX/texmf-config
# TEXMFVAR $TEXMFSYSVAR
# TEXMFCONFIG $TEXMFSYSCONFIG
# TEXMFHOME $TEXMFLOCAL

#=[ Installer options ]=========================================================
# NOTE: this has no effect, so we pass it from CLI as a flag
# instopt_portable 1

#=[ TLPDB options ]=============================================================
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_autobackup 0
# tlpdbopt_sys_bin /usr/local/bin

#=[ Platform options ]==========================================================
# No platform options.
