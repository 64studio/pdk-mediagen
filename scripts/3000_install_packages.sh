# install the custom packages

# loop over each component in the project
for COMPONENT in $(pdk listcomps $PDK_COMPONENT); do
  info "installing component $COMPONENT"

  # get rid of the directory seperator
  COMPONENT=$(echo "$COMPONENT" | tr '/' '-')

  chroot_exec apt-get install $COMPONENT^ --yes
done
