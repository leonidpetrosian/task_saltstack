install_requirements:
  pkg.installed:
    - pkgs:
      - git
      - build-essential
      - cmake
      - subversion
      - autoconf
      - automake
      - jam
      - g++
      - libsdl2-dev
      - libsdl2-image-dev 
      - libphysfs-dev
      - libvorbis-dev
      - libogg-dev
      - libopenal-dev
      - libfreetype6-dev
      - libboost-all-dev
      - libglew-dev
      - libcurl3-dev

download_supertux:
  git.latest:
    - name: https://github.com/SuperTux/supertux.git 
    - rev: master
    - target: /usr/games/supertux
  cmd.run:
    - cwd: /usr/games/supertux
    - name: "git submodule update --init --recursive"

install_supertux:
  file.directory:
    - name: /usr/games/supertux/build
  cmd.run:
    - cwd: /usr/games/supertux/build
    - name: |
        cmake ..
        make
