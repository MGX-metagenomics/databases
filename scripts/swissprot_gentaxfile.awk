#!/usr/bin/awk -f

BEGIN {
    id="";
    acc="";
    taxid="";
}

/^ID/ {
    id=$2;
}

/^AC/ {
    acc=substr($2, 1, length($2)-1);
}

/^OX/ {
    taxid=substr($2, 12, length($2)-12);
}

/^\/\// {
    print "sp|" acc "|" id " " taxid;
}
