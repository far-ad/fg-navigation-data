function dddmmss(value) {
    res=0;
    dlen=match(value,/[NSEW\.]/)-5;
    res=substr(value,1,dlen)+(substr(value,dlen+1,2)/60.0)+(substr(value,dlen+3,length(value)-3-dlen)/3600.0);
    if(substr(value,length,1) ~ /[SW]/) res=res*(-1);
    return res;
} 

{ printf "%s %.6f %.6f\n", $1,dddmmss($2),dddmmss($3); }
