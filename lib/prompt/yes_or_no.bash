import 'arguments::expect'

prompt::yes_or_no() {
  arguments::expect $# # none

  select answer in "Yes" "No"; do
    case $answer in
    Yes)
      echo "Yes"
      break
      ;;
    No)
      echo "No"
      break
      ;;
    esac
  done
}
