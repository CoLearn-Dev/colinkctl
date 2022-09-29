if ! [ -d "./colink-server-dev" ]; then
    git clone --recursive git@github.com:CoLearn-Dev/colink-server-dev.git
fi
cd colink-server-dev
cargo build --all-targets --release
cd ..
if ! [ -d "./colink-sdk-rust-dev" ]; then
    git clone --recursive git@github.com:CoLearn-Dev/colink-sdk-rust-dev.git
fi
cd colink-sdk-rust-dev
cargo build --all-targets --release
cd ..
if ! [ -d "./colink-protocol-policy-module-dev" ]; then
    git clone --recursive git@github.com:CoLearn-Dev/colink-protocol-policy-module-dev.git
fi
cd colink-protocol-policy-module-dev
sed -i '/^colink-sdk =/ccolink-sdk = { path = "../colink-sdk-rust-dev" }' Cargo.toml
cargo build --all-targets --release
cd ..
if ! [ -d "./colink-protocol-remote-storage-dev" ]; then
    git clone --recursive git@github.com:CoLearn-Dev/colink-protocol-remote-storage-dev.git
fi
cd colink-protocol-remote-storage-dev
sed -i '/^colink-sdk =/ccolink-sdk = { path = "../colink-sdk-rust-dev" }' Cargo.toml
cargo build --all-targets --release
cd ..
if ! [ -d "./colink-protocol-registry-dev" ]; then
    git clone --recursive git@github.com:CoLearn-Dev/colink-protocol-registry-dev.git
fi
cd colink-protocol-registry-dev
sed -i '/^colink-sdk =/ccolink-sdk = { path = "../colink-sdk-rust-dev" }' Cargo.toml
cargo build --all-targets --release
cd ..