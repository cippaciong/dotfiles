#! /bin/sh

kc() {
  pkg="$(pacman -Q linux | awk -F " " '{print $2}' | sed 's/\.a/\-a/')"
  # pkg="$(pacman -Q linux | awk -F " " '{print $2}' | sed 's/\.a/\.0-a/')"
  krn="$(uname -r | awk -F "-A" '{print $1}')"
  #krn="$(uname -r | awk -F "-arch" '{print $1"."$2}')"

  # Handle version mismatch between pacman and uname with
  # kernel releases of type x.y.0
  #krn_suffix="$( echo "${krn}" | cut -d . -f 3)"
  #if [ "${krn_suffix}" = "0-arch2-1" ]; then
      #krn="$(echo "${krn}" | sed 's/.0-arch2-1/-arch2-1/')"
  #fi

  # Compare kernel versions
  if [ "${pkg}" = "${krn}" ]; then
    kernel_status=""
  else
    kernel_status="Reboot (tmux sessions: $(tmux ls 2> /dev/null | cut -d ":" -f 1 | xargs))"
  fi
}

kc

echo "${kernel_status}"
