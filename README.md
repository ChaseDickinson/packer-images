# Packer Ubuntu Builds

## This repo is a work in progress

## TODO:

- Explicitly list log directories to remove after Guest Additions install
- Convert remaining scripts to Ansible Playbooks
- Organize Ansible Playbooks into Roles
- Validate/cleanup preseed files
- Configure [pre-commit](https://pre-commit.com/#intro) and use something like [this](https://github.com/cisagov/pre-commit-packer)
- Publish box to Vagrant Cloud
- Add additional OS templates (PopOS, Ubuntu server)
- Create Docker image
- Publish Docker image to Docker Hub

## Credit

Took a lot of inspiration from [Chef's Bento project](https://github.com/chef/bento) and the [Boxcutter](https://github.com/boxcutter) project, especially for Virtualbox & Vagrant configurations and the minimize/cleanup scripts.

## Problem Statement

## Repo Structure

## Usage

## What's Included

- What are you installing?
  - Ansible
  - AWS CLI
  - Docker & Docker-Compose
  - Git
  - Oh-My-Zsh
  - Packer
  - Terraform
  - Vagrant
  - Virtualbox
  - VS Code
    - Also installing some of my preferred VS Code extensions and configuration settings
