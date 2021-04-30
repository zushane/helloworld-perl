#!/usr/bin/env bash

## Sugar.
readonly bold=$(tput bold)
readonly red=$(tput setaf 1)
readonly green=$(tput setaf 2)
readonly yellow=$(tput setaf 3)
readonly cyan=$(tput setaf 6)
readonly noColour=$(tput sgr 0)

function is_this_acceptable() {
    while read -n1 -r -p "${cyan}Is this acceptable?${noColour} [${bold}Y${noColour}/n]: " yn ; do
        if [[ "$yn" != "" ]] ; then
            echo
        fi
        case $yn in 
            ""|[Yy]*) 
                printf "${cyan}Proceeding with ${bold}%s${noColour} for this build.${noColour}\n" "$new_tag"
                proceed=1
                break;;
            [Nn]*) 
                printf "${cyan}Updating.${noColour}\n"
                proceed=0
                break;;
            *)
                printf "${yellow}Please respond with ${bold}Y${noColour} or ${bold}N${noColour}.${noColour}\n"
        esac
    done
}

proceed_after_repository=0
while [ "$proceed_after_repository" -eq 0 ] ; do 
    # Get repo (default: zushane)
    read -r -p "${cyan}Enter Docker Hub repository name${noColour} [${bold}zushane${noColour}]: " repository_name
    if [[ $repository_name == "" ]] ; then 
        repository_name="zushane"
    fi

    # Get image name (default: centos-nagios)
    read -r -p "${cyan}Enter image name${noColour} [${bold}perl${noColour}]: " image_name
    if [[ $image_name == "" ]] ; then 
        image_name="perl"
    fi 

    # Get current tag (NOT latest).
    repository_image_name="${repository_name}/${image_name}"
    echo "${cyan}Checking if ${repository_image_name} exists.${noColour}"
    if ! (curl -sS "https://hub.docker.com/v2/repositories/${repository_name}/" | jq '.results? | .[]? | .name?' | grep -q "${image_name}" >/dev/null 2>&1) ; then 
        echo "${yellow}Repository ${repository_image_name} does not exist.${noColour}"
        proceed_after_repository=1
    else 
        proceed_after_repository=1
    fi
done

major=$(docker inspect "${repository_image_name}:latest" 2>/dev/null | jq --raw-output '.[0].RepoTags? | .[]?'  | grep -v latest | awk -F":" '{print $2}' | awk -F"." '{print $1}')
minor=$(docker inspect "${repository_image_name}:latest" 2>/dev/null | jq --raw-output '.[0].RepoTags? | .[]?'  | grep -v latest | awk -F":" '{print $2}' | awk -F"." '{print $2}')
point=$(docker inspect "${repository_image_name}:latest" 2>/dev/null | jq --raw-output '.[0].RepoTags? | .[]?'  | grep -v latest | awk -F":" '{print $2}' | awk -F"." '{print $3}')

# Compose new tag.
year=$(date +%Y)
if [[ "$year" -ne "$major" ]] ; then
    new_major="$year"
    new_minor="0"
    new_point="0"
else
    new_major="$major"
    new_minor="$minor"
    new_point="$((point+1))"
fi

new_tag="${new_major}.${new_minor}.${new_point}"

# Prompt for confirmation of tag name.
printf "${cyan}Suggested new tag:${noColour} ${red}%s${noColour}\n" "$new_tag"

is_this_acceptable

while [ "$proceed" -eq 0 ] ; do
    read -r -p "${cyan}Enter new tag:${noColour} " prompted_tag
    printf "${cyan}Confirm new tag:${noColour} %s\n" "$prompted_tag"
    new_tag="$prompted_tag"
    is_this_acceptable
done

#echo "new_tag: $new_tag"

# Build docker image.
printf "${cyan}Building docker image:${noColour} %s:%s\n" "${repository_image_name}" "${new_tag}"
docker build -t "${repository_image_name}:${new_tag}" -t "${repository_image_name}:latest" .

# Prompt for docker hub login. 
printf "${cyan}Clearing any existing Dockerhub login.${noColour}\n"
docker logout >/dev/null 2>&1


printf "${cyan}Please log in to Dockerhub when prompted.${noColour}\n"
while ! docker login ; do
    sleep 1
done

# Push 'latest' and new tags up to dockerhub.
docker push "${repository_image_name}:${new_tag}" 
docker push "${repository_image_name}:latest"

# Log out of docker hub.
printf "${cyan}Clearing any Dockerhub login.${noColour}\n"
docker logout >/dev/null 2>&1

echo "${green}Done!${noColour}"