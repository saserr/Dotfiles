prompt::yes_or_no() {
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