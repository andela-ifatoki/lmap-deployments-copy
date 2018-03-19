# System Maintenance Documentation
To keep the system on which LMap is running healthy and robust, it is important that some maintenance tasks are carried out. These tasks aim to:
- Keep the host OS secure by updating system packages and getting the latest security patches.
- Ensuring that storage space is conserved by running automated tasks to clean up the system.
- Incase of disaster, ensure that application data in the main database is backed-up and restorable.

## Implementation
- The default Ubuntu-Xenial image provided by GCP comes preinstalled with an apt package called *unattended_upgrades*. *unattended_upgrades* runs a cronjob that automatically installs updated packages daily, and can be configured to update all packages or just install security updates.  
>Furthermore, *unattended_upgrades* can be configured to send notifications (slack, email) each time an update occurs.  
This is currently not implemented.

- Barman (Backup and Restore Manager), an open-source administration tool for disaster recovery of PostgreSQL servers, is setup on a stand alone server to run a scheduled daily backup of the main database at 23:45hrs UTC.
### Running *unattended_upgrades*
*unattended-upgrade* is configured by editing the file `/etc/apt/apt.conf.d/50unattended-upgrades` with *sudo* level permissions. For LMap, the default configuration was used and a snippet is as below:

```
// Automatically upgrade packages from these (origin:archive) pairs
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
        // Extended Security Maintenance; doesn't necessarily exist for
        // every release and this system may not have it installed, but if
        // available, the policy for updates is such that unattended-upgrades
        // should also install from here by default.
        "${distro_id}ESM:${distro_codename}";
//      "${distro_id}:${distro_codename}-updates";
//      "${distro_id}:${distro_codename}-proposed";
//      "${distro_id}:${distro_codename}-backports";
};

// List of packages to not update (regexp are supported)
Unattended-Upgrade::Package-Blacklist {
//      "vim";
//      "libc6";
//      "libc6-dev";
//      "libc6-i686";
};
```
Obtain further information about *unattended_upgrades* from [here]("https://help.ubuntu.com/lts/serverguide/automatic-updates.html").

### Using Barman
