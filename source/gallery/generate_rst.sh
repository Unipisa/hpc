ls -R ./gallery_images | awk '
/:$/&&f{s=$0;f=0}
/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}
NF&&f{ print ".. image:: ."s"/"$0 }'