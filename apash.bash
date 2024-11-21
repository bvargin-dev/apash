#!/usr/bin/env bash

##############################################################################
# @name apash.bash
# @brief Main script managing the script libraries.
# @description
#     apash is the entry point for executing action related to
#     the project. The following action are possible:
#     * doc:    Generate the documentation of Apash.
#
#     * init:   Initialize apash sourcing in startup script.
#
#     * source: Default action which source the main function 
#               allowing to import library scripts.
#
#     * test:   Launch the unitary test campaign.
#
#  Logic:
#    Apash parses the command line in three steps:
#       1. Parse the global arguments which should be applied on the command.
#       2. Parse the action to realize.
#       3. Parse the arguments of the action and execute it.
#    Once the command line is parsed, the action is executed (only one).
#   
#   The code is split in 4 levels to execute the logic:
#   0. apashExecuteCommand (Embedded main execution flow)
#     1.|-> apashParseCommandArgs
#     1.|-> apashExecuteAction
#         2.|-> apashExecute<Action>
#             3.|-> apashParse<Action>Args
#             3.|-> Execute related subactions
#
#   This source is not essential thereafter, because the main concept is to
#   load other scripts as librairy ready to use (Source then forget).
#   
#   Note: POSIX operations as much as possible in this script.
#
# Helps ######################################################################
apashShowHelp(){
  cat << EOF
  Usage: ${0##*/} [-h|--help] [--version] ACTION [ACTION_ARGS]

  Apash command line wrapping actions for enabling features, generating
  documentation or executing tests.
  
      -h|--help|-?      display this help and exit.
      --version         display the current version of apash and exit.

  ACTIONS:
      doc               Generate documentations relative to apash.
                        Prerequisite: shdoc is avaiable.

      source            Source the apash root script for current shell.
                        Take care that this current script is sourced too.
      
      test              Execute the set of unitary tests.

  GETTING STARTED:
    First, source apash by using the source action or not passing any args:
        $ . apash       # Symbol "$" is the prompt and dot is important !
    
    Thereafter, libraries can be imported and used as following:
        $ apash.import fr.hastec.apash.commons-lang.StringUtils.indexOf
        $ StringUtils.indexOf "Gooood Morning" "M"
        # Result: 7
EOF
}

apashShowDocHelp(){
  cat << EOF
  Usage: ${0##*/} doc [-h]

  Generate the documentation (in markdown format) based on the comments.
  
      -h|--help|-?      Display this help and exit.

  PREREQUISITES: shdoc must be installed.
  Example:
  # Install basher
  $ curl -s \
    "https://raw.githubusercontent.com/basherpm/basher/master/install.sh" \
    | bash
  
  # Install shdoc
  $ basher install reconquest/shdoc

  # Open another terminal again to ensure that environment is well loaded.
EOF
}

apashShowDockerHelp(){
  cat << EOF
  Usage: ${0##*/} docker [-h] [-b|--build] [-s shell] [-v version]

  Create and run container for a specific shell or version.
  By default, it build the image if does not exist.
  
      -h|--help|-?      Display this help and exit.
      -nb|--no-build    No build of the image.
      -nr|--no-run      No run of the container.
      -s|--shell        Shell name of the image (bash|zsh).
      -v|--version      Version of the shell image.
  
  Images get the current APASH_HOME_DIR content as context.
  Images are named as following:
  local/apash:<\$APASH_VERSION>-<shell>_<shell_version>

  Images are created on top of the following:
  bash: bash         (https://hub.docker.com/_/bash/)
  zsh:  zshusers/zsh (https://hub.docker.com/r/zshusers/zsh)
  
  Example:
  # Build and run the container for bash 4.3.
  $ apash docker -s bash -v 4.3

  # Just run the version 5.9 of zsh.
  $ apash docker --build -s zsh -v 5.9
EOF
}

apashShowInitHelp(){
  cat << EOF
  Usage: ${0##*/} init [-h] [--post-install]

  Add necessary line to startup script for apash usage
  
      -h|--help|-?      Display this help and exit.
      --post-install    Add necessary lines in startup script

  Example:
  $ apash init --post-install
  Lines added to the startup up script (like \$HOME/.bashrc) with tag apashInstallTag   
  Open another terminal again to ensure that environment is well loaded.
EOF
}

apashShowSourceHelp(){
  cat << EOF
  Usage: ${0##*/} source [-h]

  Source the script with essential apash variables (apash.source).
  
      -h|--help|-?      display this help and exit.

EOF
}

apashShowMinifyHelp(){
  cat << EOF
  Usage: ${0##*/} minify [-h]

  Minify all scripts into a single file ready to source.
  All apash.imports are removed.

      -h|--help|-?      display this help and exit.

EOF
}

apashShowTestHelp(){
  cat << EOF
  Usage: ${0##*/} test [-h] [--test-options options] [--] [test paths]

  Execute unitary tests contained in the test directory.
  
      -h|--help|-?      display this help and exit.
      --test-options    options in a single argument for shellspec.
      --minified|-mn    Use minified version of apash.
      --compatibility   Launch the campaign of test to generate the
                        compatibility matrix.

  By default the shellspec command looks like:
  $ shellspec --shell bash spec/

  Example to override shellspec options:
  $ apash test --test-options "--shell bash --format tap" "\$APASH_HOME_DIR/spec"

  Example to select some tests:
  $ apash test \$APASH_HOME_DIR/spec/fr/hastec/apash/lang/Math/*.sh

  PREREQUISITES: shellspec must be installed.
  Example:
  $ curl -fsSL https://git.io/shellspec | sh -s -- --yes
  
  # Open another terminal again to ensure that environment is well loaded.
EOF
}

# LEVEL 0 - Embedded main execution flow #######################################
# @name apashExecuteCommand
# @description
#    Parse and Execute apash command.
#    Embedded main flow to prevent usage of exit statement
#    which quit the current session in case of sourcing.
apashExecuteCommand(){
  # If the current shell is not identified, then exit.
  if [ "$APASH_SHELL" != "bash" ] && [ "$APASH_SHELL" != "zsh" ]; then
    echo "Not supported shell for the moment." >&2
    return
  fi

  # Source main apash script if no argument has been passed.
  if [ $# -eq 0 ]; then
    # shellcheck disable=SC1091
    . "$APASH_HOME_DIR/src/fr/hastec/apash.sh" && return
  fi

  apashParseCommandArgs "$@"
  shift "${APASH_NB_ARGS:-0}"
  [ "$APASH_EXIT_REQUIRED" = "true" ] && return

  apashExecuteAction "$@"
}

# LEVEL 1 - Apash main command ###############################################
# @name apashParseCommandArgs
# @brief Parse the main arguments of the command line.
# @see Technical way to parse: https://mywiki.wooledge.org/BashFAQ/035
apashParseCommandArgs(){
  while :; do
    # Check if the argument is still an option
    case $1 in
      "-"*) ;;
        *) break ;;
    esac

    case $1 in
      # Show helps
      -h|-\?|--help)
        show_help
        APASH_EXIT_REQUIRED=true && return        
        ;;

      # Show the version of the scipts
      --version)
        echo "$APASH_VERSION"
        APASH_EXIT_REQUIRED=true && return
        ;;

      # End of all options.
      --)             
        shift && APASH_NB_ARGS=$(( APASH_NB_ARGS + 1 ))
        break
        ;;

      # Display error message on unknown option
      -?*)
        printf 'WARN: Unknown option: %s\n' "${1:-}" >&2
        APASH_EXIT_REQUIRED=true && return
        ;;

      # Stop parsing
      *)  # Default case: No more options, so break out of the loop.
        break
    esac
    shift && APASH_NB_ARGS=$(( APASH_NB_ARGS + 1 ))
  done
}

apashExecuteAction(){
  local action="${1:-}"
  shift
  case "$action" in
    doc)
      apashExecuteDoc "$@"
      ;;

    docker)
      apashExecuteDocker "$@"
      ;;

    init)
      apashExecuteInit "$@"
      ;;
    
    minify)
      apashExecuteMinify "$@"
      ;;

    source)
      apashExecuteSource "$@"
      ;;

    test)
      apashExecuteTest "$@"
      ;;

    -?*)
      printf 'WARN: Unknown action: %s\n' "${1:-}" >&2
      APASH_EXIT_REQUIRED=true && return
      ;;
  esac
}


# LEVEL 2 - Actions ##########################################################
apashExecuteDoc(){
    apashParseDocArgs "$@" || return
    apash.import -f "fr/hastec/apash.doc"
    if [ -z "$APASH_HOME_DIR" ] || [ ! -d "$APASH_HOME_DIR" ]; then
      echo "This operation is not allowed when the APASH directory does not exists"
      APASH_EXIT_REQUIRED=true && return
    fi
    # @todo: put a progress bar.
    echo "This operation could take few minutes..."
    (cd "$APASH_HOME_DIR" && apash.doc)
}

apashExecuteDocker(){
  local APASH_DOCKER_NO_BUILD_FLAG=false
  local APASH_DOCKER_NO_RUN_FLAG=false
  local APASH_DOCKER_SHELL="bash"
  local APASH_DOCKER_SHELL_VERSION="5.2"
  apashParseDockerArgs "$@" || return
  echo "Enter password for docker usage (if necessary)."

  # @todo: Find an elegant way to disable the --no-cache option (zsh protect evaluation).
  # Build the container
  if [ "$APASH_DOCKER_NO_BUILD_FLAG" != "true" ]; then
    $APASH_DOCKER_SUDO docker build  \
      --build-arg "SHELL_VERSION=${APASH_DOCKER_SHELL_VERSION}"                             \
      --build-arg "APASH_LOCAL_COPY=true"                                                   \
      -t "local/apash:${APASH_VERSION}-${APASH_DOCKER_SHELL}_${APASH_DOCKER_SHELL_VERSION}" \
      -f "$APASH_HOME_DIR/docker/apash-${APASH_DOCKER_SHELL}.dockerfile" "$APASH_HOME_DIR"
  fi

  # Run the container
  if [ "$APASH_DOCKER_NO_RUN_FLAG" != "true" ]; then
    $APASH_DOCKER_SUDO docker run -it --rm "local/apash:${APASH_VERSION}-${APASH_DOCKER_SHELL}_${APASH_DOCKER_SHELL_VERSION}"
  fi
}

apashExecuteInit(){
  local APASH_INIT_POST_INSTALL=false
  apashParseInitArgs "$@" || return
  [ $APASH_INIT_POST_INSTALL = "true" ] && apashExecutePostInstall
}

apashExecuteMinify(){
  apashParseMinifyArgs "$@" || return
  apash.import -f "fr/hastec/apash.minify"
  apash.minify
}

apashExecuteSource(){
  apashParseSourceArgs "$@" || return

  # shellcheck disable=SC1091
  . "$APASH_HOME_DIR/src/fr/hastec/apash.sh"
}

apashExecuteTest(){  
  # Test suboption overriding options.
  local APASH_TEST_OPTIONS="--directory $APASH_HOME_DIR --shell $APASH_SHELL "
  APASH_NB_ARGS="0"
  apashParseTestArgs "$@" || return
  shift $APASH_NB_ARGS
  APASH_TEST_FILES=("$@")
  [ $# -eq 0 ] && APASH_TEST_FILES=("$APASH_HOME_DIR/spec/")
  
  # @todo: Find a more elegant way to inject arguments (protected by zsh).
  # Split word intentionnaly the shellspec options.
  if [ "$APASH_TEST_MINIFIED" = "true" ]; then
    if [ "$APASH_SHELL" = "zsh" ]; then
      APASH_LOG_LEVEL="$APASH_LOG_LEVEL_OFF" APASH_TEST_MINIFIED=true shellspec ${(z)APASH_TEST_OPTIONS} "${APASH_TEST_FILES[@]}"
    else # bash
      # shellcheck disable=SC2086
      APASH_LOG_LEVEL="$APASH_LOG_LEVEL_OFF" APASH_TEST_MINIFIED=true shellspec $APASH_TEST_OPTIONS "${APASH_TEST_FILES[@]}"
    fi
  else
    if [ "$APASH_SHELL" = "zsh" ]; then
      APASH_LOG_LEVEL="$APASH_LOG_LEVEL_OFF" shellspec ${(z)APASH_TEST_OPTIONS} "${APASH_TEST_FILES[@]}"
    else # bash
      # shellcheck disable=SC2086
      APASH_LOG_LEVEL="$APASH_LOG_LEVEL_OFF" shellspec ${APASH_TEST_OPTIONS} "${APASH_TEST_FILES[@]}"
    fi
  fi
}

# LEVEL 3 - Parsing argument per action ########################################
apashParseInitArgs() {
  while :; do
    case ${1:-} in
      # Show helps
      -h|-\?|--help)
        apashShowInitHelp
        return $APASH_FAILURE
        ;;

      --post-install)
        APASH_INIT_POST_INSTALL=true
        ;;
      # End of all options.
      --)             
        shift
        break
        ;;

      # Display error message on unknown option
      -?*)
        printf 'WARN: Unknown option: %s\n' "${1:-}" >&2
        return $APASH_FAILURE
        ;;

      # Stop parsing
      *)
        break
    esac
    shift
  done
  return $APASH_SUCCESS
}

apashParseDocArgs() {
  while :; do
    case ${1:-} in
      # Show helps
      -h|-\?|--help)
        apashShowDocHelp
        return $APASH_FAILURE
        ;;

      # End of all options.
      --)             
        shift
        break
        ;;

      # Display error message on unknown option
      -?*)
        printf 'WARN: Unknown option: %s\n' "${1:-}" >&2
        return $APASH_FAILURE
        ;;

      # Stop parsing
      *)
        break
    esac
    shift
  done
  return $APASH_SUCCESS
}

apashParseDockerArgs() {
  while :; do
    case ${1:-} in
      # Show helps
      -h|-\?|--help)
        apashShowSourceHelp
        return $APASH_FAILURE
        ;;

      -nc|--no-cache)
        APASH_DOCKER_NO_CACHE="--no-cache"
        ;;

      -nb|--no-build)
        APASH_DOCKER_NO_BUILD_FLAG=true
        ;;

      -nr|--no-run)
        APASH_DOCKER_NO_RUN_FLAG=true
        ;;

      -s|--shell)
        if [ "${2:-}" ]; then
          APASH_DOCKER_SHELL="${2:-}"
          shift && APASH_NB_ARGS=$(( APASH_NB_ARGS + 1 ))
        fi
        ;;
      
      -v|--version)
        if [ "${2:-}" ]; then
          APASH_DOCKER_SHELL_VERSION="${2:-}"
          shift && APASH_NB_ARGS=$(( APASH_NB_ARGS + 1 ))
        fi
        ;;

      # End of all options.
      --)             
        shift
        break
        ;;

      # Display error message on unknown option
      -?*)
        printf 'WARN: Unknown option: %s\n' "${1:-}" >&2
        return $APASH_FAILURE
        ;;

      # Stop parsing
      *)
        break
    esac
    shift
  done
  return $APASH_SUCCESS
}

apashParseMinifyArgs() {
  while :; do
    case ${1:-} in
      # Show helps
      -h|-\?|--help)
        apashShowMinifyHelp
        return $APASH_FAILURE
        ;;

      # End of all options.
      --)             
        shift
        break
        ;;

      # Display error message on unknown option
      -?*)
        printf 'WARN: Unknown option: %s\n' "${1:-}" >&2
        return $APASH_FAILURE
        ;;

      # Stop parsing
      *)
        break
    esac
    shift
  done
  return $APASH_SUCCESS
}

apashParseSourceArgs() {
  while :; do

    case ${1:-} in
      # Show helps
      -h|-\?|--help)
        showApashSourceHelp
        return $APASH_EXIT_REQUIRED
        ;;

      -a|--all)
        APASH_SOURCE_ALL=true
        ;;

      # End of all options.
      --)             
        shift
        break
        ;;

      # Display error message on unknown option
      -?*)
        printf 'WARN: Unknown option: %s\n' "${1:-}" >&2
        return $APASH_EXIT_REQUIRED
        ;;

      # Stop parsing
      *)
        break
    esac
    shift
  done
  return $APASH_SUCCESS
}

apashParseTestArgs() {
  while :; do
    case ${1:-} in
      # Show helps
      -h|-\?|--help)
        apashShowTestHelp
        return $APASH_FAILURE
        ;;

      # Launch compatibility campaign
      --compatibility)
          apash.import -f "fr/hastec/apash.test.compatibility"
          apash.test.compatibility
          return $APASH_FAILURE
        ;;

      --test-options)
        if [ "${2:-}" ]; then
          APASH_TEST_OPTIONS="${2:-}"
          shift && APASH_NB_ARGS=$(( APASH_NB_ARGS + 1 ))
        fi
        ;;

      -mn|--minified)
        APASH_TEST_MINIFIED="true"
        ;;

      # End of all options.
      --)
        shift
        break
        ;;

      # Display error message on unknown option
      -?*)
        printf 'WARN: Unknown option: %s\n' "${1:-}" >&2
        return $APASH_FAILURE
        ;;

      # Stop parsing
      *)
        break
    esac
    shift && APASH_NB_ARGS=$(( APASH_NB_ARGS + 1 ))
  done
  return $APASH_SUCCESS
}

# LEVEL 3 - Sub action according to arguments ##################################
# @name apashExecutePostInstall
# @brief Add necessary instruction to startup script for apash usage.
apashExecutePostInstall(){  
  local startup_script=""
  local apash_keyword="apashInstallTag"
  case "$APASH_SHELL" in
    bash) startup_script="$HOME/.bashrc" ;;
    zsh)  startup_script="$HOME/.zshrc"  ;;
    *)    startup_script="" ;   ;;
  esac

  [ ! -w "$startup_script" ] && echo "Startup Script cannot be edited: $startup_script" >&2 && return

  if ! grep -q "$apash_keyword" "$startup_script" ; then
    (
      echo ". \"\$APASH_HOME_DIR/.apashrc\"            ##$apash_keyword"
    ) >> "$startup_script"
  else
    echo "The apash install tags are already present in $startup_script."
  fi
}

# MAIN FLOW ###################################################################
apashBashMain() {
  # Main flow is in a function to prevent usage of exit (using return instead)
  # and allow to declare variables locally.

  # Command-line flags ########################################################
  local APASH_NB_ARGS=0       # Number of argument before the action.

  # Calculated flags
  local APASH_EXIT_REQUIRED=false   # Flag set to true when an issue occurs.
  local APASH_SUCCESS=0
  local APASH_FAILURE=1

  # Zsh requires to re-declare functions when subprocesses are called.
  typeset -f "apash.import" > /dev/null || source "$APASH_HOME_DIR/src/fr/hastec/apash.import"
  apashExecuteCommand "$@"
}

apashBashMain "$@"
