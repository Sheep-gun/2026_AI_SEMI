#!/bin/csh -f

# Read-only environment inventory. Run only after secure authentication.
# This script does not print environment variables wholesale because they can
# contain tokens. It prints only selected tool and candidate PDK/library paths.
# Set AER_CADENCE_ENV only when the environment file is not located at
# $HOME/control_digi.cshrc. Set AER_CADENCE_ROOT to add a shared tool/library
# search root. Do not commit either value when it contains private site data.

set env_file = "$HOME/control_digi.cshrc"
if ($?AER_CADENCE_ENV) then
    set env_file = "$AER_CADENCE_ENV"
endif

if (-r "$env_file") then
    source "$env_file"
else
    echo "ERROR Cadence environment file is not readable"
    exit 2
endif

set search_roots = ("$HOME")
if ($?AER_CADENCE_ROOT) then
    set search_roots = ("$HOME" "$AER_CADENCE_ROOT")
else if (-d /home/tools) then
    set search_roots = ("$HOME" "/home/tools")
endif

echo "HOST"
hostname
echo "IDENTITY"
id
echo "DATE"
date -Iseconds

echo "TOOLS"
which genus
which innovus
which xrun
which conformal

echo "VERSIONS"
genus -version
innovus -version
xrun -version

echo "HOME_TOP_LEVEL"
find "$HOME" -mindepth 1 -maxdepth 2 -type d -print

echo "ENVIRONMENT_PATH_CANDIDATES"
env | egrep '^(CDS|GENUS|INNOVUS|XCELIUM|PDK|TECH|LIB|QRC|OA)_' | sed -E 's/(TOKEN|PASS|SECRET|KEY)=[^ ]+/<redacted>/g'

echo "LIBERTY_CANDIDATES"
find $search_roots -xdev -type f \( -name '*.lib' -o -name '*.lib.gz' \) -print 2>/dev/null | head -n 200

echo "LEF_CANDIDATES"
find $search_roots -xdev -type f \( -name '*.lef' -o -name '*.tlef' \) -print 2>/dev/null | head -n 200

echo "QRC_CANDIDATES"
find $search_roots -xdev -type f \( -name '*qrc*' -o -name '*captable*' -o -name 'qrcTechFile*' \) -print 2>/dev/null | head -n 200

echo "EXAMPLE_TCL_CANDIDATES"
find "$HOME" -type f \( -name '*.tcl' -o -name '*.sdc' \) -print 2>/dev/null | head -n 200
