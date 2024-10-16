#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Nginx Proxy Manager
# This file applies patches so the add-on becomes compatible
# ==============================================================================

F2B_LOG_TARGET=/proc/1/fd/1
F2B_LOG_LEVEL=${F2B_LOG_LEVEL:-INFO}
F2B_DB_PURGE_AGE=${F2B_DB_PURGE_AGE:-1d}

# Init
echo "Initializing files and folders..."
mkdir -p /config/fail2ban/db /config/fail2ban/action.d /config/fail2ban/filter.d /config/fail2ban/jail.d
ln -sf /config/fail2ban/jail.d /etc/fail2ban/

# Fail2ban conf
echo "Setting Fail2ban configuration..."
sed -i "s|logtarget =.*|logtarget = $F2B_LOG_TARGET|g" /etc/fail2ban/fail2ban.conf
sed -i "s/loglevel =.*/loglevel = $F2B_LOG_LEVEL/g" /etc/fail2ban/fail2ban.conf
sed -i "s/dbfile =.*/dbfile = \/config\/fail2ban\/db\/fail2ban\.sqlite3/g" /etc/fail2ban/fail2ban.conf
sed -i "s/dbpurgeage =.*/dbpurgeage = $F2B_DB_PURGE_AGE/g" /etc/fail2ban/fail2ban.conf
sed -i "s/#allowipv6 =.*/allowipv6 = auto/g" /etc/fail2ban/fail2ban.conf

# Check custom actions
echo "Checking for custom actions in /config/fail2ban/action.d..."
cp -rf /config/fail2ban/action.d/* /etc/fail2ban/action.d 2>/dev/null || :
#actions=$(ls -l /config/fail2ban/action.d | grep -E '^-' | awk '{print $9}')
#for action in ${actions}; do
#  if [ -f "/etc/fail2ban/action.d/${action}" ]; then
#    echo "  WARNING: ${action} already exists and will be overriden"
#    rm -f "/etc/fail2ban/action.d/${action}"
#  fi
#  echo "  Add custom action ${action}..."
#  ln -sf "/config/fail2ban/action.d/${action}" "/etc/fail2ban/action.d/"
#done

# Check custom filters
echo "Checking for custom filters in /config/fail2ban/filter.d..."
cp -rf /config/fail2ban/filter.d/* /etc/fail2ban/filter.d 2>/dev/null || :
#filters=$(ls -l /config/fail2ban/filter.d | grep -E '^-' | awk '{print $9}')
#for filter in ${filters}; do
#  if [ -f "/etc/fail2ban/filter.d/${filter}" ]; then
#    echo "  WARNING: ${filter} already exists and will be overriden"
#    rm -f "/etc/fail2ban/filter.d/${filter}"
#  fi
#  echo "  Add custom filter ${filter}..."
#  ln -sf "/share/fail2ban/filter.d/${filter}" "/etc/fail2ban/filter.d/"
#done
