default: check

.PHONY: check write-flake flake update deploy

check: #update
	nix flake check

write-flake flake: modules/dendritic/inputs.nix
	nix run .#write-flake

update: flake.nix
	nix flake update

deploy:
	deploy .#barbara-bar --skip-checks

server-%:
	hcloud server list | grep ' $* ' || \
		hcloud server create --name $* --type cx23 --image ubuntu-24.04 --ssh-key ~/.ssh/id_rsa.pub

rebuild-%:
	hcloud server rebuild --image ubuntu-24.04 $*

rescue-hetzner: flake check rebuild-barbarabar
	nix run github:nix-community/nixos-anywhere -- \
		--generate-hardware-config nixos-facter modules/hosts/barbara-bar/facter.json \
		--flake "./systems/cx23#hetzner-cloud" \
		--target-host root@$$(hcloud server ip barbarabar)

rescue-flake: flake check rebuild-barbarabar
	nix run github:nix-community/nixos-anywhere -- \
		--generate-hardware-config nixos-facter modules/hosts/barbara-bar/facter.json \
		--flake ".#barbara-bar" \
		--target-host root@$$(hcloud server ip barbarabar)

nmap-scan:
	sudo nmap -Pn -p 22 $$(hcloud server ip barbarabar)

login-test-%: nmap-scan
	ssh-keygen -R $$(hcloud server ip barbarabar)
	-ssh -vvv $*@$$(hcloud server ip barbarabar) ls /var/run/secrets
	ssh $*@$$(hcloud server ip barbarabar) hostname

native-deploy:
	nixos-rebuild switch --flake .#barbara-bar --target-host root@$$(hcloud server ip barbarabar) #--build-host foobar

# hcloud server describe -o json okidoki | , jq -r .server_type.name
.SECONDEXPANSION:
nixos-server-%: server-$$*
	mkdir -p hosts/$*
	ssh-keygen -R $$(hcloud server ip $*)
	ssh root@$$(hcloud server ip $*) cat /etc/os-release | grep ID=nixos || \
		nix run github:nix-community/nixos-anywhere -- \
						--debug \
						--generate-hardware-config nixos-generate-config ./hosts/$*/hardware-configuration.nix \
						--flake ./systems/cx23#hetzner-cloud \
						--target-host root@$$(hcloud server ip $*)
	ssh-keygen -R $$(hcloud server ip $*)

