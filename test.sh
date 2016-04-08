# (c) Adam Serafini 2016

# My ad-hoc framework for testing bash CLI projects.

# It works as follows:
# 1. Create a tests directory for your project.
# 2. Put this script in the directory.
# 3. Each test lives in its own file and starts with 't' and a 4 digit number.
# 4. The script iterates through every test.
# 5. If all test scripts return 0: the tests pass and this script returns 0.
# 6. If 1 or more tests fail, they return 1 and so does this script.

# Get the test directory.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo 'Tests failed :-('
exit 1
