function dbuild() {
    local __doc__="usage: dbuild [-p] NAME\nBuilds (and optionally pushes) the container called NAME\nfrom the directory in ~/.config/dbuild/dir\n(currently: $(cat ~/.config/dbuild/dir))"

    local OPTIND
    local build=1

    while getopts ":aAph" opt; do
        case $opt in
            a)
                local mkalias=1
                ;;
            A)
                build=0
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

    shift $(($OPTIND-1))
    
    local name=${1:-$(basename $(pwd))}
    local repo="ilowe/$name"
    local wd="$(cat ~/.config/dbuild/dir)/$name"

    [ "$build" = "1" ] && { pushd $wd; docker build -t $repo .; popd; }
    [ "$push" = "1" ] && docker push $repo
    [ "$mkalias" = "1" ] && ___dbuild-mkdockeralias $name && echo "Added alias $name"
}

function ___dbuild-rmdocker() {
    local id=$(docker ps -a | grep ilowe/$1 | sed 's: .*::')
    [ "$id" != "" ] && docker rm -f $id
}

function ___dbuild-mkdockeralias() {
    local fname=$(mktemp)
    local root=$(cat ~/.config/dbuild/dir)

    cat <<EOF > $fname
${1}() {
    if [ "\$1" == "-h" ]; then
        echo "$(grep '^#' $root/$1/Dockerfile | head -1 | sed 's:^# ::g')"
        return
    fi

    ___dbuild-rmdocker $1
EOF
    grep -e '^#' -e '^\s*$' $root/$1/Dockerfile | tail -n +3 | sed 's:^#\s::g' | while read line; do
        if echo $line | grep '^\s*$'; then 
            break
        fi
        echo "$line"
    done >> $fname

    echo "}" >> $fname

    source $fname
    rm -f $fname
}