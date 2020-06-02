#!/bin/bash
father_vline="│   "  #边界竖线
block="    "  #边界空格
child_level="├── "  #中间文件
last_file="└── "  #最后一个文件
level_sum="" 

#蓝背景色为文件夹
#蓝色为符号链接
#白色为文件

tip(){
    echo "    默认遍历展示所有非隐藏文件"
    echo "    可选项 -[option]:"
    echo "    -a -----------> 展示所有文件"
    echo "    -d -----------> 只展示文件夹"
}

tree_only_dirs(){

    #当前第几个文件夹
    local total_num=0
    #一次访问每个文件夹
    for file in `ls -al|grep "^d\|^l" |awk '{print $9}'|grep -vw "\.\|\.\.\|''"`
    do
        #最后一个文件夹的序号
        theLastDir=`ls -al|grep "^d\|^l"|grep -vw "\.\|\.\."|wc -l`
        #total_num+1
        total_num=$((total_num+1))
        if [[ $total_num -eq $theLastDir ]] #如果是最后一个文件夹
        then
            if [ -L $file ]  #是符号链接
            then
                lnfile=`ls -l $file|awk '{print $11}'` #获取指向的文件或者文件夹
                if [ -d $lnfile ]  #如果是文件夹
                then 
                    echo -e "$level_sum$last_file\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"  
                    level_sum=$level_sum$block
                    cd "$file"
                    tree_only_dirs
                    cd ../
                    level_sum=${level_sum%$block}
                fi
            else
                echo -e "$level_sum$last_file\033[46;30m$file\033[0m"
                level_sum=$level_sum$block  #添加一个block
                cd "$file"
                tree_only_dirs
                cd ../
                level_sum=${level_sum%$block} #删除一个block
            fi
            
        else             #非最后一个文件夹
            if [ -L $file ] #是符号链接
            then
                lnfile=`ls -l $file|awk '{print $11}'`
                if [ -d $lnfile ]
                then 
                    echo -e "$level_sum$child_level\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"  
                    level_sum=$level_sum$father_vline
                    cd "$file"
                    tree_only_dirs
                    cd ../
                    level_sum=${level_sum%$father_vline}
                fi
            else
                echo -e "$level_sum$child_level\033[46;30m$file\033[0m"
                level_sum=$level_sum$father_vline  #添加一个block
                cd "$file"
                tree_only_dirs
                cd ../
                level_sum=${level_sum%$father_vline} #删除一个block
            fi
            
        fi
    done
}

tree_all(){
    #当前第几个文件
    local total_num=0
    #一次访问每个文件
    for file in `ls -a|grep -vw "\.\|\.\."`
    do
        #最后一个文件的序号
        theLastDir=`ls -a|grep -vw "\.\|\.\."|wc -l`
        #total_num+1
        total_num=$((total_num+1))
        if [[ $total_num -eq $theLastDir ]] #如果是最后一个
        then
            if [ -L $file ]  #如果是符号链接, 必须先判断，否则指向文件的符号链接会被认作文件
            then
                lnfile=`ls -l $file|awk '{print $11}'`
                if [ -d $lnfile ]
                then 
                    echo -e "$level_sum$last_file\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                    level_sum=$level_sum$block  #添加一个block
                    cd "$file"
                    tree_all
                    cd ../
                    level_sum=${level_sum%$block} #删除一个block
                elif [ -L $lnfile ]
                then
                    echo -e "$level_sum$last_file\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                else
                    echo -e "$level_sum$last_file\033[34m$file\033[0m -> $lnfile"
                fi
            elif [ -f $file ]  #如果是文件
            then
                echo -e "$level_sum$last_file$file"
            

            else        #是文件夹
                echo -e "$level_sum$last_file\033[46;30m$file\033[0m"
                level_sum=$level_sum$block  #添加一个block
                cd "$file"
                tree_all
                cd ../
                level_sum=${level_sum%$block} #删除一个block
            fi
        else             #非最后一个文件夹
            if [ -L $file ]  #如果是符号链接
            then
                lnfile=`ls -l $file|awk '{print $11}'`
                if [ -d $lnfile ]
                then 
                    echo -e "$level_sum$child_level\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                    level_sum=$level_sum$father_vline  #添加一个block
                    cd "$file"
                    tree_all
                    cd ../
                    level_sum=${level_sum%$father_vline} #删除一个block
                elif [ -L $lnfile ]
                then
                    echo -e "$level_sum$child_level\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                else
                    echo -e "$level_sum$child_level\033[34m$file\033[0m -> $lnfile"
                fi
            elif [ -f $file ]
            then
                echo -e "$level_sum$child_level$file"
            else
                echo -e "$level_sum$child_level\033[46;30m$file\033[0m"
                level_sum=$level_sum$father_vline
                cd "$file"
                tree_all
                cd ../
                level_sum=${level_sum%$father_vline}
            fi
        fi
    done
}

tree(){
    #当前第几个文件
    local total_num=0
    #一次访问每个文件
    for file in `ls|grep -vw "\.\|\.\."`
    do
        #最后一个文件的序号
        theLastDir=`ls|grep -vw "\.\|\.\."|wc -l`
        #total_num+1
        total_num=$((total_num+1))
        if [[ $total_num -eq $theLastDir ]] #如果是最后一个
        then
            if [ -L $file ]  #如果是符号链接, 必须先判断，否则指向文件的符号链接会被认作文件
            then
                lnfile=`ls -l $file|awk '{print $11}'`
                if [ -d $lnfile ]
                then 
                    echo -e "$level_sum$last_file\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                    level_sum=$level_sum$block  #添加一个block
                    cd "$file"
                    tree
                    cd ../
                    level_sum=${level_sum%$block} #删除一个block
                elif [ -L $lnfile ]
                then
                    echo -e "$level_sum$last_file\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                else
                    echo -e "$level_sum$last_file\033[34m$file\033[0m -> $lnfile"
                fi
            elif [ -f $file ]  #如果是文件
            then
                echo -e "$level_sum$last_file$file"
            else        #是文件夹
                echo -e "$level_sum$last_file\033[46;30m$file\033[0m"
                level_sum=$level_sum$block  #添加一个block
                cd "$file"
                tree
                cd ../
                level_sum=${level_sum%$block} #删除一个block
            fi
        else             #非最后一个文件夹
            if [ -L $file ]  #如果是符号链接
            then
                lnfile=`ls -l $file|awk '{print $11}'`
                if [ -d $lnfile ]
                then 
                    echo -e "$level_sum$child_level\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                    level_sum=$level_sum$father_vline  #添加一个block
                    cd "$file"
                    tree
                    cd ../
                    level_sum=${level_sum%$father_vline} #删除一个block
                elif [ -L $lnfile ]
                then
                    echo -e "$level_sum$child_level\033[34m$file\033[0m -> \033[46;30m$lnfile\033[0m"
                else
                    echo -e "$level_sum$child_level\033[34m$file\033[0m -> $lnfile"
                fi
            elif [ -f $file ]
            then
                echo -e "$level_sum$child_level$file"
            else
                echo -e "$level_sum$child_level\033[46;30m$file\033[0m"
                level_sum=$level_sum$father_vline
                cd "$file"
                tree
                cd ../
                level_sum=${level_sum%$father_vline}
            fi
        fi
    done
}


if [ $# = 2 ]
then
    if [ $1 == "-a" ]
    then
        cd $2
        if [[ $? -eq 0 ]]; 
        then
            echo -e "\033[46;30m$2\033[0m"
            tree_all
        fi
    elif [ $1 == "-d" ]
    then
        cd $2
        if [[ $? -eq 0 ]]; 
        then
            echo -e "\033[46;30m$2\033[0m"
            tree_only_dirs
        fi
    else
        tip
    fi
elif [ $# = 1 ]
then
    cd $1
    if [[ $? -eq 0 ]]; 
    then
        echo -e "\033[46;30m$1\033[0m"
        tree
    fi        
elif [ $# = 0 ]
then
    cd ./
    if [[ $? -eq 0 ]]; 
    then
        echo -e "\033[46;30m.\033[0m"
        tree
    fi 
else 
    echo "too many arguments!"
fi
