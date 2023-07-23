Lang = {
    Command = {
        name = "vipmenu",
        help = "Open vip menu (Admin Only)"
    },
    Menu = {
        title = "Admin vip menu",
        Give = "Give vip",
        Check = "Check vip",
        Remove = "Remove vip"
    },
    Give = {
        Input = {
            title = 'Give vip',
            id = 'ID',
            rank = 'Rank name',
            expire = 'Expire date',
            permanent = 'Permanent'
        },
        Alert = {
            title = 'Give vip',
            content = 'ID: {id}  \nRank: {rank}  \nExpire date: {expire}  \nPermanent: {permanent}'
        },
        Notify = {
            error = {
                noexpiredate = "Please enter an expiration date",
                playernotfound = "Player not found",
                invalidRank  = "This rank doesn't exist",
                cantgive = "The VIP could not be delivered, the 'license' is invalid"
            },
            success = {
                gived_src = "You have been granted the VIP: {rank}",
                gived_target = "You have received the VIP: {rank}"
            }
        },
    },
    Check = {
        Input = {
            title = 'Check vip',
            id = 'ID',
        },
        Alert = {
            title = 'Vip status',
            content = 'ID: {id}  \nVip: {label}  \nExpire date: {expire}'
        },
        Notify = {
            error = {
                playernotfound = "Player not found",
                novip = "This player doesn't have VIP"
            },
        },
    },
    Remove = {
        Input = {
            title = 'Remove vip',
            id = 'ID',
        },
        Alert = {
            title = 'Vip status',
            content = 'ID: {id}  \nVip: {label}  \nExpire date: {expire}',
            confirm = 'Remove'
        },
        Notify = {
            error = {
                playernotfound = "Player not found",
                novip = "This player doesn't have VIP"
            },
            success = {
                removed_src = "The VIP has been removed",
                removed_target = "Your VIP has been removed"
            }
        },
    },
    Icons = {
        id = 'user',
        rank = 'gem',
        calendar = {'far', 'calendar'},
        Menu = {
            Give = 'medal',
            Check = 'calendar',
            Remove = 'trash'
        }
    }
}