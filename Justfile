backup:
    @bash backup.sh

patch:
    @bash patch.sh

install: && patch
    @bash install.sh
