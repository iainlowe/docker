function dbuild() {
    local __doc__="usage: dbuild [-p] NAME\nBuilds (and optionally pushes) the container called NAME\nfrom the directory in ~/.config/dbuild/dir\n(currently: $(cat ~/.config/dbuild/dir))"

    local OPTIND

    while getopts ":aph" opt; do
        case $opt in
            a)
                local mkalias=1
                ;;
            p)
                local push=1
                ;;
            h)
                echo -ne ${__doc__}
                return
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                ;;
        esac
    done
    echo $OPTIND
    shift $(($OPTIND-1))
    
    local name=$1
    local repo="ilowe/$name"
    local wd="$(cat ~/.config/dbuild/dir)/$name"

    { pushd $wd; docker build -t $repo .; popd; }

    [ -n "$push" ] && docker push $repo
    [ -n "$mkalias" ] && ___dbuild-mkdockeralias $1
}

function ___dbuild-mkdockeralias() {
    local fname=$(mktemp)
    local root=$(cat ~/.config/dbuild/dir)

    cat <<EOF > $fname
function $1 {
    if [ "\$1" == "-h" ] || [ "\$1" == "--help" ]; then
        echo "$(grep '^#' $root/$1/Dockerfile | head -1 | sed 's:^# ::g')"
        return
    fi
EOF
    grep -e '^#' -e '^\s*$' $root/$1/Dockerfile | tail -n +3 | sed 's:^#\s::g' | while read line; do if echo $line | grep '^\s*$'; then break; fi; echo $line; done >> $fname
    echo "}" >> $fname

    source $fname
    rm -f $fname
}