from fabric.api import env, put, run
from os.path import exists

env.hosts = ['100.25.130.238', '52.201.146.131']
env.user = 'your-username'
env.key_filename = '/home/ubuntu/.ssh/id_rsa'


def do_deploy(archive_path):
    if not exists(archive_path):
        return False

    try:
        # Upload the archive to the /tmp/ directory of the web server
        put(archive_path, '/tmp/')

        # Extract the archive to the /data/web_static/releases/<archive filename without extension> folder
        archive_filename = archive_path.split('/')[-1]
        folder_name = '/data/web_static/releases/{}'.format(archive_filename.split('.')[0])
        run('mkdir -p {}'.format(folder_name))
        run('tar -xzf /tmp/{} -C {}'.format(archive_filename, folder_name))

        # Remove the archive from the web server
        run('rm /tmp/{}'.format(archive_filename))

        # Delete the existing symbolic link
        run('rm -f /data/web_static/current')

        # Create a new symbolic link to the new version of your code
        run('ln -s {} /data/web_static/current'.format(folder_name))

        return True
    except Exception as e:
        print(e)
        return False
