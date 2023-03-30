export RUNTIME_DIR="$BATS_TEST_TMPDIR"
source 'lib/configure.bash'

__test_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
load "$__test_dir/helpers/run.bash"
