import os
import ldap

ldap_server = "ldap://localhost"
ldap_port = 389
ldap_bind_dn = "cn=admin,dc=example,dc=org"
ldap_bind_password = "admin"
ldap_search_base = "dc=example,dc=org"
ldap_group_filter = "(&(objectClass=groupOfUniqueNames)(cn=access_laser_ftp))"
ldap_member_attribute = "uniqueMember"

try:
    # Connect to LDAP server
    l = ldap.initialize(ldap_server + ":" + str(ldap_port))
    l.simple_bind_s(ldap_bind_dn, ldap_bind_password)
    print("Connected to LDAP server")
except ldap.LDAPError as e:
    print(f"Error connecting to LDAP server: {e}")
    exit()

# Search for group
result_id = l.search(ldap_search_base, ldap.SCOPE_SUBTREE, ldap_group_filter, [ldap_member_attribute])
result_type, result_data = l.result(result_id, 0)
if not result_data:
    print("Group not found")
    l.unbind_s()
    exit()

# Check if users are members of group and create directories
group_dn, group_attrs = result_data[0]
if ldap_member_attribute in group_attrs:
    members = group_attrs[ldap_member_attribute]
    members = [bytes_string.decode('utf-8') for bytes_string in members]
    for member in members:
        user = member.split(',')[0][4:]
        ldap_member_dn = member
        directory = "./data/" + user
        if f"uid={user},ou=people,dc=example,dc=org" in members and group_dn == "cn=access_laser_ftp,ou=groups,dc=example,dc=org":
            # Create directory if user is in group
            if not os.path.exists(directory):
                os.mkdir(directory)
                print(f"Created directory for user: {user}")
            else:
                print(f"Directory for user {user} already exists")
else:
    print("No members found in group")

# Unbind from LDAP server
l.unbind_s()
