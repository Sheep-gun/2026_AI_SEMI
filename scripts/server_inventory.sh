#!/bin/csh -f

# Read-only environment inventory. Run only after secure authentication.
# This script does not print environment variables wholesale because they can
# contain tokens. It prints only selected tool and candidate PDK/library paths.

if (-r /home/aiasic26211/control_digi.cshrc) then
    source /home/aiasic26211/control_digi.cshrc
else
    echo "ERROR control_digi.cshrc is not readable"
    exit 2
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
find /home/aiasic26211 -mindepth 1 -maxdepth 2 -type d -print

echo "ENVIRONMENT_PATH_CANDIDATES"
env | egrep '^(CDS|GENUS|INNOVUS|XCELIUM|PDK|TECH|LIB|QRC|OA)_' | sed -E 's/(TOKEN|PASS|SECRET|KEY)=[^ ]+/<redacted>/g'

echo "LIBERTY_CANDIDATES"
find /home/aiasic26211 /home/tools -xdev -type f \( -name '*.lib' -o -name '*.lib.gz' \) -print 2>/dev/null | head -n 200

echo "LEF_CANDIDATES"
find /home/aiasic26211 /home/tools -xdev -type f \( -name '*.lef' -o -name '*.tlef' \) -print 2>/dev/null | head -n 200

echo "QRC_CANDIDATES"
find /home/aiasic26211 /home/tools -xdev -type f \( -name '*qrc*' -o -name '*captable*' -o -name 'qrcTechFile*' \) -print 2>/dev/null | head -n 200

echo "EXAMPLE_TCL_CANDIDATES"
find /home/aiasic26211 -type f \( -name '*.tcl' -o -name '*.sdc' \) -print 2>/dev/null | head -n 200

