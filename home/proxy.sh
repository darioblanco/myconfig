# Discovers if a HTTP and HTTPS proxy is set in MacOS
if [ -x "$(which scutil)" ]; then
    # Retrieve proxy addresses
    proxy=$(scutil --proxy | awk '\
        /HTTPEnable/ { enabled = $3; } \
        /HTTPProxy/ { server = $3; } \
        /HTTPPort/ { port = $3; } \
        END { if (enabled == "1") { print "http://" server ":" port; } }')
    if [ "$proxy" = "" ]; then
        # No proxy: remove any proxy related environment variables
        unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
    else
        # Proxy configured: set the related environment variables
        export http_proxy="${proxy}"
        export HTTP_PROXY="${proxy}"
        export https_proxy="${proxy}"
        export HTTPS_PROXY="${proxy}"
    fi
fi
