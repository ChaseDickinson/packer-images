# Packer Ubuntu Builds

## This repo is a work in progress

## TODO:

- Ansible playbook to clear disk utilization
  - Analyze disk utilization to determine if/what can be removed
  - Anonymize disk by zeroing root, boot, & swap
- Continue working to convert bash scripts to Ansible playbooks (full build)
- Add [Pop!_OS Shell](https://github.com/pop-os/shell) to full build
- Organize Ansible playbooks into roles
  - Create role for build server
- Add better conditions (virtualization technology and guest OS) into roles to provide more robust controls for if/when tasks run
- Validate/cleanup preseed files
- Configure [pre-commit](https://pre-commit.com/#intro) and use something like [this](https://github.com/cisagov/pre-commit-packer)
- Publish box to Vagrant Cloud
- Add additional OS templates (Pop!_OS)
- Add server builds (Ubuntu server)
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
