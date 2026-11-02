-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-whoami = 当前已登录 { $name }@{ $host }
msg-auth-login-oauth_unsupported =
    您安装的 forge 不支持对 { $host_domain } 使用 `login`

    请访问 { $applications_url }
    创建令牌，并使用 `forge auth add-key` 登录
msg-auth-login-canceled = 登录已取消
msg-auth-login-browser_success = 已认证！请关闭此标签页并返回终端。
msg-auth-login-browser_failure = 认证失败。
msg-auth_logout-success = 已退出登录 { $host }
msg-auth_logout-already_signed_out = 尚未登录 { $host }
msg-auth-use_ssh-not_logged_in = 未登录 { $host }
msg-auth-use_ssh-enabled = 现在将默认对 { $host } 使用 SSH
msg-auth-use_ssh-disabled = 将不再默认对 { $host } 使用 SSH
msg-auth-use_ssh-already_enabled = 已默认对 { $host } 使用 SSH
msg-auth-use_ssh-already_disabled = 尚未默认对 { $host } 使用 SSH
msg-auth-add_token-prompt = 新密钥：
msg-auth-add_token-already_exists = { $host } 的密钥已存在
msg-auth-list-none = 无登录记录。
msg-actions-variable-create-already_exists = 变量已存在，请传递 --force 以替换它。
msg-actions-variable-create-already_exists_forced = 变量已存在，正在更新。
msg-actions-variable-delete-success = 变量 { $name } 已删除。
msg-actions-dispatch-success =
    已在 { $ref } 中调度工作流 { $name }，包含 { $n_inputs ->
        [one] 1 个输入
       *[other] { $n_inputs } 个输入
    }。
msg-org-list-no_results = 无结果。
msg-org-list-page_number = 第 { $page } 页，共 { $total } 页
msg-org-view-org_name =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    }
msg-org-view-visibility =
    { $visibility ->
        [public] 公开
        [limited] 受限
       *[private] 私有
    }
msg-org-view-member_count =
    { $member_count ->
        [one] { STYLE("bold") }1{ STYLE("reset") } 个成员
       *[other] { STYLE("bold") }{ $member_count }{ STYLE("reset") } 个成员
    }
msg-org-view-team_count =
    { $team_count ->
        [one] { STYLE("bold") }1{ STYLE("reset") } 个团队
       *[other] { STYLE("bold") }{ $team_count }{ STYLE("reset") } 个团队
    }
msg-org-create-invalid_character =
    组织名称只能包含字母数字字符、短横线、下划线或句点。
      如果您希望名称包含其他字符，请尝试设置 --full-name 标志
msg-org-create-invalid_starting_character =
    组织名称只能以字母数字字符开头。
      如果您希望名称以其他字符开头，请尝试设置 --full-name 标志
msg-org-create-invalid_ending_character =
    组织名称只能以字母数字字符结尾。
      如果您希望名称以其他字符结尾，请尝试设置 --full-name 标志
msg-org-create-invalid_consecutive_characters =
    组织名称不能包含连续的非字母数字字符。
      如果您希望在名称中包含此类字符，请尝试设置 --full-name 标志
msg-org-create-success =
    已创建新的{ $visibility ->
        [public] 公开
        [limited] 受限
       *[private] 私有
    }组织 { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    }
msg-org-members-no_results = 无结果。
msg-org-members-page_number = 第 { $page } 页，共 { $total } 页
msg-org-members-entry =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $username }){ STYLE("reset") }
    }
msg-org-visibility-public = 您是 { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") } 的公开成员
msg-org-visibility-private = 您是 { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") } 的私有成员
msg-org-visibility-set_public = 您现在已是 { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") } 的公开成员
msg-org-visibility-set_private = 您现在已是 { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") } 的私有成员
msg-org-visibility-not_member = 您不是 { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") } 的成员
msg-org-label-add-success = 已创建新标签 { $label }
msg-org-label-edit-success = 已将标签 { $old_label } 更改为 { $label }
msg-org-label-remove-success = 已移除标签 { $label }
msg-org-repo-list-no_results = 无结果。
msg-org-repo-list-page_number = 第 { $page } 页，共 { $total } 页
msg-org-team-view =
    { STYLE("bright-blue", "bold") }{ $name }{ STYLE("reset") } 在组织 { STYLE("bold") }{ $org }{ STYLE("reset") } 中 { $admin ->
        [yes] { -dash } { STYLE("bright-red") }管理员{ STYLE("reset") }
       *[no] { "" }
    }
msg-org-team-view-read_only = 只读：
msg-org-team-view-read_write = 读/写：
msg-org-team-view-perms-wiki = Wiki
msg-org-team-view-perms-ext_wiki = 外部 Wiki
msg-org-team-view-perms-issues = 议题
msg-org-team-view-perms-ext_issues = 外部议题
msg-org-team-view-perms-pulls = 合并请求
msg-org-team-view-perms-projects = 项目
msg-org-team-view-perms-actions = CI
msg-org-team-view-perms-code = 代码
msg-org-team-view-perms-releases = 版本发布
msg-org-team-view-perms-packages = 软件包
msg-org-team-create-success =
    已在组织 { STYLE("bold") }{ $org }{ STYLE("reset") } 中创建新的{ $admin ->
        [yes] 管理员
       *[no] { "" }
    }团队 { STYLE("bright-blue", "bold") }{ $name }{ STYLE("reset") }
msg-org-team-delete-confirmation = 您确定要删除 { STYLE("bold") }{ $org }/{ $name }{ STYLE("reset") } 吗？
    .yes =
        是
        是
        Y
        y
    .no =
        否
        否
        N
        n
msg-org-team-repo-list-no_results = 无结果。
msg-org-team-repo-list-page_number = 第 { $page } 页，共 { $total } 页
msg-org-team-repo-add-success = 已将 { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } 添加到团队 { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-repo-rm-success = 已将 { STYLE("bold") }{ $org }/{ $repo }{ STYLE("reset") } 从团队 { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") } 中移除
msg-org-team-member-list-no_results = 无结果。
msg-org-team-member-list-page_number = 第 { $page } 页，共 { $total } 页
msg-org-team-member-add-success = 已将 { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } 添加到团队 { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") }
msg-org-team-member-rm-success = 已将 { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } 从团队 { STYLE("bold", "bright-blue") }{ $team }{ STYLE("reset") } 中移除
msg-issue-create-no_templates = { $owner }/{ $repo } 没有任何议题模板
msg-issue-create-templates_required =
    { $owner }/{ $repo } 要求使用模板。
    请使用 `--template <NAME>` 选择一个。
msg-issue-create-templates_enabled =
    { $owner }/{ $repo } 使用议题模板。
    请使用 `--template <NAME>` 选择一个，
    或使用 `--no-template` 从头编写一个。
msg-issue-create-success = 已创建议题 #{ $number }：{ $title }
msg-issue-view-header =
    { STYLE("yellow") }{ $title } { STYLE("dark-grey") }#{ $number }{ STYLE("reset") }
    作者：{ STYLE("white") }{ $author }{ STYLE("reset") } { -dash } { $state ->
        [open] { STYLE("bright-green") }开启{ STYLE("reset") }
        [closed] { STYLE("bright-red") }已关闭{ STYLE("reset") }
       *[other] $state
    }
msg-issue-view-comment_count =
    { $comments ->
        [one] 1 条评论
       *[other] { $comments } 条评论
    }
msg-issue-search-entry = #{ $number }：{ $title }（作者：{ $author }）
msg-issue-templates-none = 没有议题模板或联系信息。
msg-issue-templates-blank_allowed = 允许使用“--no-template”
msg-issue-templates-blank_not_allowed = 不允许使用“--no-template”
msg-issue-view-comments-comment_header =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") } 说：
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("dark-gray") }({ $username }){ STYLE("reset") } 说：
    }
msg-issue-view-comments-attachments =
    { $attachments ->
        [one] 1 个附件
       *[other] { $attachments } 个附件
    }
msg-issue-edit-title-empty = 标题不能为空
msg-issue-edit-title-no_newlines = 标题不能包含换行符
msg-issue-assign-success =
    已将 { $added ->
        [one] 1 个用户
       *[other] { $added } 个用户
    } 分配到 { $owner }/{ $repo }#{ $number } { $duplicate ->
        [0] { "" }
        [one]
            { $added ->
                [0] （用户已被分配）
               *[other] （1 个用户已被分配）
            }
       *[other]
            { $added ->
                [0] （所有用户已被分配）
               *[other] （{ $duplicate } 个用户已被分配）
            }
    }
msg-issue-unassign-success =
    已从 { $owner }/{ $repo }#{ $number } 取消分配 { $removed ->
        [one] 1 个用户
       *[other] { $removed } 个用户
    } { $duplicate ->
        [0] { "" }
        [one]
            { $removed ->
                [0] （用户未被分配）
               *[other] （1 个用户未被分配）
            }
       *[other]
            { $removed ->
                [0] （所有用户均未被分配）
               *[other] （{ $duplicate } 个用户未被分配）
            }
    }
msg-issue-close-success = 已关闭议题 #{ $number }：“{ $title }”
msg-pr-couldnt_guess = 无法猜测合并请求编号，请指定
msg-pr-not_found = 找不到 PR
msg-pr-view-header =
    { STYLE("yellow") }{ $title } { STYLE("dark-grey") }#{ $number }{ STYLE("reset") }
    作者：{ STYLE("white") }{ $username }{ STYLE("reset") } { -dash } { $state ->
        [draft] { STYLE("light-grey") }草稿{ STYLE("reset") }
        [open] { STYLE("bright-green") }开启{ STYLE("reset") }
        [merged] { STYLE("bright-magenta") }已合并{ STYLE("reset") }
        [closed] { STYLE("bright-red") }已关闭{ STYLE("reset") }
       *[other] $state
    } { -dash } { STYLE("bright-green") }+{ $additions } { STYLE("bright-red") }-{ $deletions }{ STYLE("reset") }
    { OPT($head_branch) ->
       *[none] 合并到 `{ $base_branch }`
        [some] 从 `{ $head_branch }` 合并到 `{ $base_branch }`
    }
msg-pr-view-comment_count =
    { $comments ->
        [one] 1 条评论
       *[other] { $comments } 条评论
    }
msg-pr-status-merged = { STYLE("bright-magenta") }已由{ STYLE("reset") } { $merged_by } 于 { DATETIME($merged_at, dateStyle: "long", timeStyle: "long") } 合并
msg-pr-status-header =
    { $state ->
        [draft] { STYLE("light-grey") }草稿{ STYLE("reset") } { -dash } 无法合并草稿 PR
        [open]
            { STYLE("bright-green") }开启{ STYLE("reset") } { -dash } { $mergeable ->
               *[yes] 可以合并
                [no] { STYLE("bright-red") }合并冲突{ STYLE("reset") }
            }
        [closed] { STYLE("bright-red") }已关闭{ STYLE("reset") } { -dash } 重新开启以合并
       *[other] 未知
    }
msg-pr-status-entry =
    { $state ->
        [success] { STYLE("bright-green") }成功{ STYLE("reset") }
        [pending] { STYLE("yellow") }待处理{ STYLE("reset") }
        [warning] { STYLE("bright-yellow") }警告{ STYLE("reset") }
        [failure] { STYLE("bright-red") }失败{ STYLE("reset") }
        [skipped] { STYLE("grey") }跳过{ STYLE("RESET") }
        [error] { STYLE("bright-red") }错误{ STYLE("reset") }
       *[other] 未知
    } { -dash } { $context }
msg-pr-review-list-none = 无评审。
msg-pr-review-list-only_stale = 只有陈旧或已驳回的评审，请使用 --all 来显示它们。
msg-pr-review-list-review_header =
    { $review_type ->
        [approved] { STYLE("bright-green") }已批准{ STYLE("reset") }
        [changes-requested] { STYLE("bright-yellow") }请求变更{ STYLE("reset") }
        [comment] { STYLE("bright-yellow") }评论{ STYLE("reset") }
        [pending] { STYLE("light-grey") }待评审{ STYLE("reset") }
       *[other] 未知
    }，来自 { STYLE("bold") }{ $reviewer }{ STYLE("reset") }
    { STYLE("dark-grey") }{ $comments ->
        [one] 1 条评论
       *[other] { $comments } 条评论
    }，发表于 { DATETIME($timestamp, dateStyle: "long", timeStyle: "short") }{ STYLE("reset") } { $state ->
        [stale] { STYLE("bold") }（陈旧）{ STYLE("reset") }
        [dismissed] { STYLE("bold") }（已驳回）{ STYLE("reset") }
       *[other] { "" }
    }
msg-pr-review-list-comment_position = 在 { STYLE("bold") }{ $path }：{ $position }{ STYLE("reset") } 中：
msg-pr-review-list-comment_header =
    { STYLE("bold", "bright-cyan") }{ $commenter }{ STYLE("reset") } 评论了 { OPT($resolver) ->
       *[none] { "" }
        [some] （由 { $resolver } 解决）
    }：
msg-pr-create-cross_instance = 无法跨实例创建合并请求；基础分支位于 { $base_instance }，而头部分支跟踪的是 { $head_instance }
msg-pr-create-success = 已创建合并请求 #{ $number }：{ $title }
msg-pr-create-agit_success = 已创建合并请求：{ $title }
msg-pr-create-agit_push_cfg_question =
    是否要设置所需的 git 配置项，
    以便 `git push` 对此 PR 生效？
msg-pr-create-agit_push_cfg_prompt = （y/N/?）
    .yes =
        是
        是
        Y
        y
    .no =
        否
        否
        N
        n
    .help =
        帮助
        帮助
        H
        h
        ？
msg-pr-create-agit_force_push_warning =
    { STYLE("bold") }注意：{ STYLE("reset") }
      AGit PR 不支持 `git push --force[-with-lease]`。
      您可以使用 `git push -o force=true` 代替。
msg-pr-create-agit_push_cfg_help = 这将设置以下配置选项：
msg-pr-merge-commit_title_unsupported-rebase = 变基不支持提交标题
msg-pr-merge-commit_title_unsupported-ff = ff-only 不支持提交标题
msg-pr-merge-commit_title_unsupported-manual = 手动合并不支持提交标题
msg-pr-merge-default_message = 评审地址：{ $pr_url }
msg-pr-merge-success = 已将 PR #{ $number }“{ $title }”合并到“{ $base_branch }”
msg-pr-checkout-dirty = 无法检出 PR；工作目录存在未提交的更改
msg-pr-checkout-not_fork = 无法获取父仓库，{ $repo } 不是分叉仓库
msg-pr-checkout-success =
    已检出 PR #{ $number }：{ $title }
    { $new_branch ->
       *[yes] 在新分支 { $branch_name } 上
        [no] 已将分支更新到最新提交
    }
msg-pr-search-entry = #{ $number }：{ $title }（作者：{ $author }）
msg-pr-view-diff-volatile = 对差异所做的更改将不会保留
msg-repo-no_host_given = 找不到仓库，未指定主机
msg-repo-no_info_given =
    未指定仓库信息

    如果您尝试对当前目录中的仓库进行操作，请尝试添加一个指向
    Forgejo 实例的远程仓库。如果您有多个远程仓库，请尝试将其中一个设置为
    当前分支的上游。您也可以使用 `--host` 参数显式指定主机。
msg-repo-fallback_host-invalid_url = 警告：`FJ_FALLBACK_HOST` 未设置为有效的 URL
msg-repo-arg_no_owner = 仓库名称格式应为 [HOST/]OWNER/NAME
msg-repo-name_needed = 无法获取仓库名称，请指定
msg-repo-create-remote_exists = 名为“{ $remote_name }”的远程仓库已存在
msg-repo-create-success = 已在 { $url } 创建新仓库
msg-repo-create-detached_head = HEAD 不在任何分支上；无法推送到远程仓库
msg-repo-create-branch_invalid_utf8 = 分支名称包含无效的 UTF-8 字符
msg-repo-fork-conflicting_hosts = 主机 { $host_a } 和 { $host_b } 冲突，请仅指定一个
msg-repo-fork-success = 已将 { $parent_owner }/{ $parent_name } 分叉到 { $fork_name }
msg-repo-migrate-git_only = 从 `git` 服务迁移不支持除 LFS 之外的迁移项目。请指定其他服务或移除包含的项目
msg-repo-migrate-username_prompt = 用户名：
msg-repo-migrate-password_prompt = 密码：
msg-repo-migrate-token_prompt = 令牌：
msg-repo-migrate-migrating = 正在迁移...
msg-repo-migrate-success = 完成！在线查看：{ $url }
msg-repo-view-name = { $repo_name }
msg-repo-view-is_fork = 分叉自 { $parent }
msg-repo-view-is_mirror = 镜像自 { $mirror_of }
msg-repo-view-primary_language = 主要语言为 { $language }
msg-repo-view-stars =
    { $stars ->
        [one] 1 颗星
       *[other] { $stars } 颗星
    }
msg-repo-view-watching = { $watching } 人关注中
msg-repo-view-forks =
    { $forks ->
        [one] 1 个分叉
       *[other] { $forks } 个分叉
    }
msg-repo-view-issues =
    { $issues ->
        [one] 1 个议题
       *[other] { $issues } 个议题
    }
msg-repo-view-prs =
    { $pull_requests ->
        [one] 1 个 PR
       *[other] { $pull_requests } 个 PR
    }
msg-repo-view-releases =
    { $releases ->
        [one] 1 个版本发布
       *[other] { $releases } 个版本发布
    }
msg-repo-view-external_tracker = 议题跟踪器位于 { $url }
msg-repo-view-url = 在线查看：{ $url }
msg-repo-readme-none = 仓库没有 README
msg-repo-clone-preparing = { "   " }正在准备...
msg-repo-clone-downloading = { " " }正在下载... { NUMBER($percent, maximumFractionDigits: 2) }%（{ NUMBER($size, maximumFractionDigits: 2) }{ $units }）
msg-repo-clone-resolving = { "   " }正在解析... { NUMBER($percent, maximumFractionDigits: 2) }%
msg-repo-clone-finishing_up = 正在完成...
msg-repo-clone-success = 已将 { $repo } 克隆到 { $path }
msg-repo-star-success = 已点赞 { $owner }/{ $repo }！
msg-repo-unstar-success = 已取消点赞 { $owner }/{ $repo }！
msg-repo-delete-confirmation_prompt = 您确定要删除 { $owner }/{ $name } 吗？（y/N）
    .yes =
        是
        是
        Y
        y
    .no =
        否
        否
        N
        n
msg-repo-delete-success = 已删除 { $owner }/{ $repo }
msg-repo-delete-cancelled = 未删除
msg-repo-label-view-archived = （已归档）
msg-repo-label-view-no_description = （无描述）
msg-repo-label-create-success = 成功创建标签 { $label }
msg-repo-label-delete-success = 成功删除标签 { $label }
msg-repo-label-edit-success = 已编辑标签：{ $label }
msg-user-search-page_zero = 没有第 0 页
msg-user-search-fail = 搜索失败
msg-user-search-none = 没有用户匹配该查询
msg-user-search-page_too_high =
    { $total_pages ->
        [one] 只有 1 页
       *[other] 只有 { $total_pages } 页
    }
msg-user-search-footer =
    显示第 { STYLE("bold") }{ $first_index }{ -dash }{ $last_index }{ STYLE("reset") } 条结果，共 { STYLE("bold") }{ $total_results }{ STYLE("reset") } 条（{ $page }/{ $total_pages }）
    { $more ->
        [yes] 使用 --page 标志查看更多
       *[no] { "" }
    }
msg-user-view-header =
    { STYLE("bright-cyan", "bold") }{ $username }{ STYLE("reset") } { OPT($pronouns) ->
       *[none] { "" }
        [some] { STYLE("light-grey") } { -dash } { STYLE("bold") }{ $pronouns }{ STYLE("reset") }
    }
    { $followers ->
        [one] { STYLE("bold") }1{ STYLE("reset") } 个粉丝
       *[other] { STYLE("bold") }{ $followers }{ STYLE("reset") } 个粉丝
    } { -dash } { STYLE("bold") }{ $following }{ STYLE("reset") } 人关注
    { OPT($website) ->
       *[none]
            { OPT($email) ->
               *[none] { "" }
                [some] { STYLE("bold") }{ $email }{ STYLE("reset") }
            }
        [some]
            { OPT($email) ->
               *[none] { STYLE("bold") }{ $website }{ STYLE("reset") }
                [some] { STYLE("bold") }{ $website }{ STYLE("reset") } { -dash } { STYLE("bold") }{ $email }{ STYLE("reset") }
            }
    }
msg-user-view-joined_on = 于 { STYLE("bold") }{ DATETIME($joined, dateStyle: "medium") }{ STYLE("reset") } 加入
msg-user-follow-success = 已关注 { $username }
msg-user-unfollow-success = 已取消关注 { $username }
msg-user-following-none-other = { $user } 没有关注任何人
msg-user-following-none-self = 您还没有关注任何人
msg-user-following-other = { $user } 关注的人：
msg-user-following-self = 您关注的人：
msg-user-followers-none-other = { $user } 没有粉丝
msg-user-followers-none-self = 您还没有粉丝 :(
msg-user-followers-other = 关注 { $user } 的人：
msg-user-followers-self = 关注您的人：
msg-user-block-success = 已屏蔽 { $user }
msg-user-unblock-success = 已解除屏蔽 { $user }
msg-user-repos-none-starred-other = { $name } 未点赞任何仓库
msg-user-repos-none-starred-self = 您还没有点赞任何仓库
msg-user-repos-none-other = { $name } 没有任何仓库
msg-user-repos-none-self = 您没有任何仓库
msg-user-repos-list_footer =
    显示第 { STYLE("bold") }{ $first_index }{ -dash }{ $last_index }{ STYLE("reset") } 条结果，共 { STYLE("bold") }{ $total_results }{ STYLE("reset") } 条（{ $page }/{ $total_pages }）
    { $more ->
        [yes] 使用 --page 标志查看更多
       *[no] { "" }
    }
msg-user-orgs-none-other = { $user } 还不是任何组织的成员
msg-user-orgs-none-self = 您还不是任何组织的成员
msg-user-orgs-count =
    { $organizations ->
        [one] 1 个组织
       *[other] { $organizations } 个组织
    }
msg-activity-created_fork = { STYLE("bold") }{ $actor }{ STYLE("reset") } 将仓库 { STYLE("bold", "yellow") }{ $parent_repo_name }{ STYLE("reset") } 分叉到 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_mirror = { STYLE("bold") }{ $actor }{ STYLE("reset") } 创建了镜像 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } 创建了仓库 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-renamed_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } 将仓库从 { STYLE("bold", "yellow") }"{ $old_name }"{ STYLE("reset") } 重命名为 { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") }
msg-activity-starred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } 点赞了仓库 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-watched_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } 关注了仓库 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-pushed_commit = { STYLE("bold") }{ $actor }{ STYLE("reset") } 推送到 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } 上的 { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") }
msg-activity-created_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } 开启了议题 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } 创建了合并请求 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-transferred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } 将仓库 { STYLE("bold", "yellow") }"{ $old_name }"{ STYLE("reset") } 转移至 { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") }
msg-activity-pushed_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } 将标签 { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } 推送到 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-commented_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } 评论了议题 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-merged_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } 合并了合并请求 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-closed_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } 关闭了议题 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-reopened_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } 重新开启了议题 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-closed_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } 关闭了 PR { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-reopened_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } 重新开启了 PR { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-deleted_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } 从 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } 删除了标签 { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") }
msg-activity-deleted_branch = { STYLE("bold") }{ $actor }{ STYLE("reset") } 从 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } 删除了分支 { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") }
msg-activity-approved_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } 已批准 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-rejected_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } 对 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } 提出了更改建议
msg-activity-commented_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } 评论了合并请求 { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_release = { STYLE("bold") }{ $actor }{ STYLE("reset") } 在 { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") } 上创建了版本发布 { STYLE("bold", "bright-cyan") }{ $release_name }{ STYLE("reset") }
msg-user-edit-name-removal_hint = 使用 --unset 从您的个人资料中移除姓名
msg-user-edit-pronouns-removal_hint = 使用 --unset 从您的个人资料中移除代词
msg-user-edit-location-removal_hint = 使用 --unset 从您的个人资料中移除位置信息
msg-user-edit-website-removal_hint = 使用 --unset 从您的个人资料中移除网站
msg-user-key-list-count = 密钥总数：{ $keys }
msg-user-key-list-header = { STYLE("bold") }密钥 { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-key-list-title = { STYLE("bold") }标题：{ STYLE("reset") }       { STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
msg-user-key-list-created_at = { STYLE("bold") }创建时间：{ STYLE("reset") }  { STYLE("bright-cyan") }{ DATETIME($created_at, dateStyle: "short", timeStyle: "medium") }{ STYLE("reset") }
msg-user-key-list-type = { STYLE("bold") }类型：{ STYLE("reset") }        { STYLE("bright-cyan") }{ $key_type }{ STYLE("reset") }
msg-user-key-list-fingerprint = { STYLE("bold") }指纹：{ STYLE("reset") } { STYLE("bright-cyan") }{ $fingerprint }{ STYLE("reset") }
msg-user-key-delete-success = 已成功删除 ID 为 { $id } 的密钥
msg-user-key-upload-home_not_found = 无法定位主目录。请为密钥文件提供显式路径。
msg-user-key-upload-keys_not_found = 未找到密钥。
msg-user-key-upload-confirm_key_file_prompt =
    猜测的密钥文件：{ $path }
    看起来是否正确？
    .yes =
        是
        是
        Y
        y
    .no =
        否
        否
        N
        n
msg-user-key-add-file_unconfirmed = 用户未确认猜测的密钥文件。
msg-user-key-add-unexpected_extension =
    “{ $path }”不以“.pub”结尾。您确定这不是私钥吗？
     如果您仍要继续，请添加 --force。
msg-user-key-add-invalid_key =
    “{ $path }”看起来像私钥或无效数据！
     如果您仍要继续，请添加 --force。
msg-user-key-add-no_title = 无法猜测密钥标题，请明确提供一个并检查您的密钥文件。
msg-user-key-upload-confirm_key_title_prompt =
    猜测的标题：{ STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
    看起来是否正确？
    .yes =
        是
        是
        Y
        y
    .no =
        否
        否
        N
        n
msg-user-key-add-title_unconfirmed = 用户未确认猜测的标题。
msg-user-key-add-success = 密钥创建成功！
msg-user-gpg-list-count = 密钥总数：{ $keys }
msg-user-gpg-list-header = { STYLE("bold") }密钥 { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-gpg-list-key_id = { STYLE("bold") }密钥 ID：{ STYLE("reset") }              { STYLE("bright-cyan") }{ $key_id }{ STYLE("reset") }
msg-user-gpg-list-can_sign =
    { STYLE("bold") }可签名：{ STYLE("reset") }            { $can_sign ->
        [yes] { STYLE("bright-green") }是{ STYLE("reset") }
       *[no] { STYLE("bright-red") }否{ STYLE("reset") }
    }
msg-user-gpg-list-can_encrypt_comms =
    { STYLE("bold") }可加密通信：{ STYLE("reset") }   { $can_encrypt_comms ->
        [yes] { STYLE("bright-green") }是{ STYLE("reset") }
       *[no] { STYLE("bright-red") }否{ STYLE("reset") }
    }
msg-user-gpg-list-can_encrypt_storage =
    { STYLE("bold") }可加密存储：{ STYLE("reset") } { $can_encrypt_storage ->
        [yes] { STYLE("bright-green") }是{ STYLE("reset") }
       *[no] { STYLE("bright-red") }否{ STYLE("reset") }
    }
msg-user-gpg-list-can_certify =
    { STYLE("bold") }可认证：{ STYLE("reset") }         { $can_certify ->
        [yes] { STYLE("bright-green") }是{ STYLE("reset") }
       *[no] { STYLE("bright-red") }否{ STYLE("reset") }
    }
msg-user-gpg-list-verified =
    { STYLE("bold") }已验证：{ STYLE("reset") }            { $verified ->
        [yes] { STYLE("bright-green") }是{ STYLE("reset") }
       *[no] { STYLE("bright-red") }否{ STYLE("reset") }
    }
msg-user-gpg-list-email =
    { STYLE("bright-cyan") }{ $email }{ STYLE("reset") } { $verified ->
        [yes] 已验证
       *[no] 未验证
    }
msg-user-gpg-list-subkey = { STYLE("bold") }子密钥 { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }：
msg-user-gpg-upload-exporting = 正在导出密钥...
msg-user-gpg-upload-export_failed =
    导出密钥失败。{ OPT($status_code) ->
       *[none] { "" }
        [some] GPG 状态：{ $status_code }
    }
msg-user-gpg-upload-success = 密钥添加成功！
msg-user-gpg-verify-fetching_token = 正在获取验证令牌...
msg-user-gpg-verify-signing_token = 正在使用密钥“{ $key_name }”签署验证令牌...
msg-user-gpg-verify-signing_failed =
    签署验证令牌失败。{ OPT($status_code) ->
       *[none] { "" }
        [some] GPG 状态：{ $status_code }
    }
msg-user-gpg-verify-key_to_verify = 正在验证此密钥：
msg-user-gpg-verify-success = 验证成功！
msg-user-gpg-delete-confirmation_prompt = 删除 GPG 密钥将导致该密钥签名的所有提交变为未验证！是否继续？
    .yes =
        是
        是
        Y
        y
    .no =
        否
        否
        N
        n
msg-user-gpg-delete-unconfirmed = 用户中止了进程。
msg-user-gpg-delete-success = ID 为 { $id } 的密钥已成功删除。
msg-release-create-must_specify_tag = 必须使用 `--tag` 或 `--create-tag` 选择标签
msg-release-create-tag_flags_conflict = “--tag”和“--create-tag”互斥，请仅选择其中一个
msg-release-create-success = 已创建版本发布 { $name }
msg-release-list-entry =
    { $name } { $state ->
       *[neither] { "" }
        [draft] （草稿）
        [prerelease] （预发布）
        [both] （草稿，预发布）
    }
msg-release-view-header =
    { $name }
    作者：{ $author }，版本发布于 { DATETIME($created_at, dateStyle: "long") }
msg-release-asset-create-success = 已将附件“{ $asset }”添加到 { $release }
msg-release-asset-delete-success = 已从 { $release } 中移除附件“{ $asset }”
msg-release-asset-download-success =
    { OPT($file) ->
       *[none] 已下载 { $asset }
        [some] 已将 { $asset } 下载到 { $file }
    }
msg-tag-create-success = 已创建标签 { $name }
msg-tag-delete-success = 已删除标签 { $name }
msg-version-update_check-hint = 使用 `forge version --check` 检查新版本
msg-version-update_check-current = 已是最新！
msg-version-update_check-behind =
    新版本可用：{ $new_version }
    获取地址：{ $url }
msg-version-update_check-ahead = 您领先于最新的已发布版本
msg-wiki-clone-success = 已将 { $repo } 的 wiki 克隆到 { $path }
help-arg-remote = 指向要操作的仓库的本地 git 远程仓库
help-arg-repo = 要操作的仓库
help-cmd-auth-login = 登录到实例
help-cmd-auth-login-long =
    登录到实例

    在浏览器中打开认证页面
help-cmd-auth-logout = 删除实例的登录信息
help-cmd-auth-use_ssh = 启用或禁用在特定实例中默认使用 SSH
help-cmd-auth-add_token = 为实例添加应用程序令牌
help-cmd-auth-add_token-long =
    为实例添加应用程序令牌

    如果 `forge auth login` 无效，请使用此选项。
help-arg-auth-add_token-token = 要添加的密钥。如果未提供，将从标准输入读取密钥
help-cmd-auth-list = 列出您当前已登录的所有实例
help-cmd-actions-tasks = 列出仓库上的任务
help-arg-actions-tasks-page = 要显示的页码。每页最多包含 20 个任务
help-cmd-actions-variables = 列出并管理变量
help-cmd-actions-variables-list = 列出变量
help-arg-actions-variables-list-verbose = 同时打印 owner_id 和 repo_id
help-cmd-actions-variables-create = 创建新变量
help-arg-actions-variables-create-name = 新变量的名称
help-arg-actions-variables-create-data = 要保存到变量中的数据。省略则调用编辑器
help-arg-actions-variables-create-force = 覆盖现有变量
help-cmd-actions-variables-delete = 删除变量
help-arg-actions-variables-delete-name = 要删除的变量
help-cmd-actions-dispatch = 调度工作流程
help-arg-actions-dispatch-name = 要调度的工作流程名称
help-arg-actions-dispatch-ref = 要调度工作流程的 Git 修订版本
help-arg-actions-dispatch-inputs = 作为运行输入的值
help-cmd-actions-secrets = 列出并管理机密
help-cmd-actions-secrets-list = 列出机密
help-cmd-actions-secrets-create = 创建新的操作机密
help-arg-actions-secrets-create-name = 新机密的名称
help-arg-actions-secrets-create-data = 要保存到机密中的数据
help-cmd-actions-secrets-delete = 删除操作机密
help-arg-actions-secrets-delete-name = 要删除的机密
help-cmd-org-list = 列出所有组织
help-arg-org-list-page = 要查看的结果页码
help-arg-org-list-only_member_of = 仅列出您是其成员的组织
help-cmd-org-view = 查看组织信息
help-arg-org-view-name = 要查看的组织名称
help-arg-org-options-full_name = 组织的显示名称
help-arg-org-options-full_name-long =
    组织的显示名称

    这没有 `name` 参数的限制，可以包含任何 UTF-8 文本。
help-arg-org-options-description = 组织的描述
help-arg-org-options-email = 组织的联系电子邮件
help-arg-org-options-location = 组织的位置
help-arg-org-options-website = 组织的网站
help-arg-org-options-visibility = 组织的可见性
help-arg-org-options-visibility-long =
    组织的可见性

    公共组织任何人都可以查看，受限组织仅登录用户可以查看，私有组织仅该组织的成员可以查看。
help-arg-org-options-admin_can_change_team_access = 仓库管理员是否可以更改组织团队对其的访问权限
help-cmd-org-create = 创建新组织
help-arg-org-create-name = 组织的用户名
help-arg-org-create-name-long =
    组织的用户名

    只能包含字母数字字符、短横线、下划线或句点。必须以字母数字字符开头和结尾，且不能有连续的短横线、下划线或句点。

    如果您想要一个不受这些限制的名称，请参阅 `--full-name` 选项。
help-cmd-org-edit = 编辑组织信息
help-arg-org-edit-name = 要编辑的组织名称
help-arg-org-edit-name-long =
    要编辑的组织名称

    请注意这是用户名，*不是*显示名称。
help-cmd-org-activity = 查看组织中的活动
help-arg-org-activity-name = 要查看活动的组织名称
help-cmd-org-members = 列出组织成员
help-arg-org-members-org = 要查看成员的组织名称
help-arg-org-members-page = 要查看的结果页码
help-cmd-org-visibility = 查看并更改您在组织中的成员可见性
help-arg-org-visibility-org = 要查看您可见性的组织名称
help-arg-org-visibility-set = 为自己设置新的可见性
help-cmd-org-label-list = 列出组织使用的所有议题标签
help-arg-org-label-list-org = 要列出标签的组织名称
help-cmd-org-label-add = 向组织添加新的议题标签
help-arg-org-label-add-org = 要添加标签的组织名称
help-arg-org-label-add-name = 要添加的标签名称
help-arg-org-label-add-color = 要添加的标签的十六进制颜色代码
help-arg-org-label-add-description = 标签用途的描述
help-arg-org-label-add-exclusive = 如果此标签命名为 { "`{scope}/{name}`" }，则使其与同一作用域的其他标签互斥
help-cmd-org-label-edit = 编辑组织使用的议题标签
help-arg-org-label-edit-org = 标签所属的组织名称
help-arg-org-label-edit-name = 要编辑的标签名称
help-arg-org-label-edit-new_name = 为标签设置新名称
help-arg-org-label-edit-color = 为标签设置新的十六进制颜色代码
help-arg-org-label-edit-description = 设置标签用途的描述
help-arg-org-label-edit-exclusive = 设置此标签是否与同一作用域的其他标签互斥
help-arg-org-label-edit-archived = 设置此标签是否已归档
help-cmd-org-label-rm = 从组织移除议题标签
help-arg-org-label-rm-org = 标签所属的组织名称
help-arg-org-label-rm-label = 要从组织移除的标签名称
help-cmd-org-repo-list = 列出该组织拥有的所有仓库
help-arg-org-repo-list-org = 要列出仓库的组织名称
help-arg-org-repo-list-page = 要查看的结果页码
help-cmd-org-repo-create = 在此组织中创建新仓库
help-arg-org-repo-create-org = 要创建仓库的组织名称
help-cmd-org-team-list = 查看组织中的所有团队
help-arg-org-team-list-org = 要列出团队的组织名称
help-cmd-org-team-view = 查看单个团队的信息
help-arg-org-team-view-org = 团队所属的组织名称
help-arg-org-team-view-name = 要查看的团队名称
help-arg-org-team-options-description = 团队职责的描述
help-arg-org-team-options-read_permissions = 授予该团队的读权限列表，以逗号分隔
help-arg-org-team-options-read_permissions-long =
    授予该团队的读权限列表，以逗号分隔

    权限列表：
     - wiki
     - ext_wiki
     - issues
     - ext_issues
     - pulls
     - projects
     - actions
     - code
     - releases
     - packages

    或者，您可以使用 `all` 允许所有读权限。
help-arg-org-team-options-write_permissions = 授予该团队的读写权限列表，以逗号分隔
help-arg-org-team-options-write_permissions-long =
    授予该团队的读写权限列表，以逗号分隔

    权限列表：
     - wiki
     - ext_wiki
     - issues
     - ext_issues
     - pulls
     - projects
     - actions
     - code
     - releases
     - packages

    或者，您可以使用 `all` 允许所有读写权限
help-cmd-org-team-create = 创建新团队
help-arg-org-team-create-org = 要创建团队的组织名称
help-arg-org-team-create-name = 新团队的名称
help-arg-org-team-create-name-long =
    新团队的名称

    只能包含字母数字字符
help-arg-org-team-create-can_create_repos = 允许该团队成员在组织中创建仓库
help-arg-org-team-create-include_all_repos = 授予该团队对所有仓库的访问权限
help-arg-org-team-create-admin = 授予该团队在组织中的管理员权限
help-cmd-org-team-edit = 编辑团队信息和权限
help-arg-org-team-edit-org = 团队所属的组织名称
help-arg-org-team-edit-name = 要编辑的团队名称
help-arg-org-team-edit-can_create_repos = 允许该团队成员在组织中创建仓库
help-arg-org-team-edit-include_all_repos = 授予该团队对所有仓库的访问权限
help-arg-org-team-edit-admin = 授予该团队在组织中的管理员权限
help-cmd-org-team-delete = 从组织删除团队
help-cmd-org-team-delete-long =
    从组织删除团队

    请注意，这不会删除团队拥有的仓库！
help-arg-org-team-delete-org = 团队所属的组织名称
help-arg-org-team-delete-name = 要删除的团队名称
help-cmd-org-team-repo-list = 列出该团队可以访问的所有仓库
help-arg-org-team-repo-list-org = 团队所属的组织名称
help-arg-org-team-repo-list-team = 要查看仓库的团队名称
help-arg-org-team-repo-list-page = 要查看的结果页码
help-cmd-org-team-repo-add = 向团队添加现有仓库的访问权限
help-arg-org-team-repo-add-org = 团队所属的组织名称
help-arg-org-team-repo-add-team = 要添加仓库的团队名称
help-arg-org-team-repo-add-repo = 要添加到团队的仓库名称
help-cmd-org-team-repo-rm = 从团队移除仓库的访问权限
help-cmd-org-team-repo-rm-long =
    从团队移除仓库的访问权限

    请注意，这不会删除仓库！
help-arg-org-team-repo-rm-org = 团队所属的组织名称
help-arg-org-team-repo-rm-team = 要移除仓库的团队名称
help-arg-org-team-repo-rm-repo = 要从团队移除的仓库名称
help-cmd-org-team-member-list = 列出团队的所有成员
help-arg-org-team-member-list-org = 团队所属的组织名称
help-arg-org-team-member-list-team = 要查看成员的团队名称
help-arg-org-team-member-list-page = 要查看的结果页码
help-cmd-org-team-member-add = 向团队添加成员
help-arg-org-team-member-add-org = 团队所属的组织名称
help-arg-org-team-member-add-team = 要添加用户的团队名称
help-arg-org-team-member-add-user = 要添加到团队的用户名称
help-cmd-org-team-member-rm = 从团队移除成员
help-arg-org-team-member-rm-org = 团队所属的组织名称
help-arg-org-team-member-rm-team = 要移除用户的团队名称
help-arg-org-team-member-rm-user = 要从团队移除的用户名称
help-cmd-issue-create = 在仓库上创建新议题
help-arg-issue-create-title = 议题标题
help-arg-issue-create-body = 议题的正文
help-arg-issue-create-body-long =
    议题的正文

    省略此项将打开编辑器，除非指定了 --body-file。
help-arg-issue-create-body_file = 从中读取议题正文的文件
help-arg-issue-create-template = 创建议题时使用的模板
help-arg-issue-create-template-long =
    创建议题时使用的模板

    如果仓库已禁用空白议题，则此标志为必填项。
help-arg-issue-create-no_template = 对此议题不使用模板
help-arg-issue-create-no_template-long =
    对此议题不使用模板

    如果仓库已禁用空白议题，此操作将失败。
help-arg-issue-create-repo = 要创建此议题的仓库
help-arg-issue-create-web = 在浏览器中打开议题创建页面
help-cmd-issue-view = 查看议题信息
help-arg-issue-view-issue = 要查看的议题
help-cmd-issue-view-body = 查看议题的标题和正文。默认选项
help-cmd-issue-view-comment = 查看特定评论
help-cmd-issue-view-comments = 列出所有评论
help-cmd-issue-search = 在仓库中搜索议题
help-arg-issue-search-repo = 要搜索的仓库
help-arg-issue-search-state = 按状态筛选议题。默认：open
help-cmd-issue-templates = 列出仓库中的议题模板
help-arg-issue-templates-repo = 要查看模板的仓库
help-cmd-issue-edit = 编辑议题
help-cmd-issue-edit-title = 编辑议题标题
help-cmd-issue-edit-body = 编辑议题的文本内容
help-cmd-issue-edit-comment = 编辑议题上的评论
help-cmd-issue-edit-labels = 编辑议题的标签
help-arg-issue-edit-labels-add = 要添加的标签
help-arg-issue-edit-labels-rm = 要移除的标签
help-cmd-issue-comment = 在议题上添加评论
help-arg-issue-comment-issue = 要评论的议题
help-arg-issue-comment-body = 评论的文本内容
help-arg-issue-comment-body-long =
    评论的文本内容

    省略此项将打开编辑器，除非指定了 --body-file。
help-arg-issue-comment-body_file = 从中读取评论文本内容的文件
help-cmd-issue-assign = 将用户分配给议题
help-arg-issue-assign-issue = 要分配用户的议题
help-arg-issue-assign-users = 要分配给此议题的用户名
help-cmd-issue-unassign = 取消将用户分配给议题
help-arg-issue-unassign-issue = 要取消分配用户的议题
help-arg-issue-unassign-users = 要从此议题取消分配的用户名
help-cmd-issue-close = 关闭议题
help-arg-issue-close-issue = 要关闭的议题
help-arg-issue-close-with_msg = 关闭前要在议题上留下的评论
help-cmd-issue-browse = 在浏览器中打开议题
help-cmd-pr-view = 查看合并请求的内容
help-arg-pr-view-id = 要查看的合并请求
help-cmd-pr-view-body = 查看合并请求的标题和正文
help-cmd-pr-view-comment = 查看合并请求上的评论
help-arg-pr-view-comment-idx = 要查看的评论索引，从 0 开始
help-cmd-pr-view-comments = 查看合并请求上的所有评论
help-cmd-pr-view-labels = 查看应用于合并请求的标签
help-cmd-pr-view-diff = 查看合并请求的基础分支和头部分支之间的差异
help-arg-pr-view-diff-patch = 以补丁格式获取差异
help-arg-pr-view-diff-editor = 在文本编辑器中查看差异
help-cmd-pr-view-files = 查看合并请求中更改的文件
help-cmd-pr-view-commits = 查看合并请求中的提交
help-arg-pr-view-commits-oneline = 每行显示一个提交
help-cmd-pr-status = 查看合并请求的可合并性和 CI 状态
help-arg-pr-status-id = 要查看的合并请求
help-arg-pr-status-wait = 等待所有检测完成后退出
help-cmd-pr-review = 管理合并请求上的评审
help-arg-pr-review-id = 要操作的合并请求
help-cmd-pr-review-list = 列出合并请求上的评审
help-arg-pr-review-list-comments = 列出合并请求评审中的内联评论
help-arg-pr-review-list-all = 包含所有评审，包括陈旧的和已驳回的
help-cmd-pr-create = 创建新的合并请求
help-arg-pr-create-base = 要合并到的分支
help-arg-pr-create-head = 要拉取更改的分支
help-arg-pr-create-title = 新合并请求的标题
help-arg-pr-create-title-long =
    新合并请求的标题

    以 "WIP: " 为前缀将此 PR 标记为草稿。
help-arg-pr-create-body = 合并请求的正文
help-arg-pr-create-body-long =
    合并请求的正文

    省略此项将打开编辑器，除非指定了 --body-file。
help-arg-pr-create-body_file = 要从中读取的议题正文文件
help-arg-pr-create-autofill = 从提交中自动填充 PR 的标题和正文
help-arg-pr-create-autofill-long =
    从提交中自动填充 PR 的标题和正文

    如果只有一个提交，则 PR 将匹配其标题和内容。
    否则标题将为分支标题，内容将包含每个提交消息的列表。
help-arg-pr-create-repo = 要创建此合并请求的仓库
help-arg-pr-create-web = 在浏览器中打开 PR 创建页面
help-arg-pr-create-agit = 使用 AGit 工作流打开 PR
help-cmd-pr-merge = 合并合并请求
help-arg-pr-merge-pr = 要合并的合并请求
help-arg-pr-merge-method = 要使用的合并方式
help-arg-pr-merge-delete = 之后是否删除相应分支的选项
help-arg-pr-merge-title = 要创建的合并或压缩提交的标题
help-arg-pr-merge-message = 要创建的合并或压缩提交的正文
help-cmd-pr-checkout = 在新分支中检出合并请求
help-arg-pr-checkout-pr = 要检出的合并请求
help-arg-pr-checkout-pr-long =
    要检出的合并请求

    以 ^ 为前缀以获取来自父仓库的合并请求。
help-arg-pr-checkout-branch_name = 新创建分支的名称
help-arg-pr-checkout-branch_name-long =
    新创建分支的名称

    默认为以主机 URL、仓库所有者和 PR 编号命名。
help-arg-pr-checkout-ssh = 使用 SSH 而不是 HTTP(S) 拉取提交
help-arg-pr-checkout-identity_file = 通过 SSH 克隆时要使用的 SSH 密钥文件
help-cmd-pr-comment = 在合并请求上添加评论
help-arg-pr-comment-pr = 要评论的合并请求
help-arg-pr-comment-body = 评论的文本内容
help-arg-pr-comment-body-long =
    评论的文本内容

    省略此项将打开编辑器，除非指定了 --body-file。
help-arg-pr-comment-body_file = 从中读取评论文本内容的文件
help-cmd-pr-assign = 将用户分配给合并请求
help-arg-pr-assign-users = 要分配给此 PR 的用户名
help-cmd-pr-unassign = 取消将用户分配给合并请求
help-arg-pr-unassign-users = 要从此 PR 取消分配的用户名
help-cmd-pr-edit = 编辑合并请求的内容
help-arg-pr-edit-pr = 要编辑的合并请求
help-cmd-pr-edit-title = 编辑标题
help-arg-pr-edit-title-new_title = 新的 PR 标题
help-arg-pr-edit-title-new_title-long =
    新的 PR 标题

    省略此项将在编辑器中打开当前标题。
help-cmd-pr-edit-body = 编辑正文
help-arg-pr-edit-body-new_body = 新的 PR 正文
help-arg-pr-edit-body-new_body-long =
    新的 PR 正文

    省略此项将在编辑器中打开当前正文。
help-cmd-pr-edit-comment = 编辑评论
help-arg-pr-edit-comment-idx = 要编辑的评论索引，从 0 开始
help-arg-pr-edit-comment-new_body = 新的评论正文
help-arg-pr-edit-comment-new_body-long =
    新的评论正文

    省略此项将在编辑器中打开当前正文。
help-cmd-pr-edit-labels = 编辑应用的标签
help-arg-pr-edit-labels-add = 要添加的标签
help-arg-pr-edit-labels-rm = 要移除的标签
help-cmd-pr-close = 关闭合并请求，不合并
help-arg-pr-close-pr = 要关闭的合并请求
help-arg-pr-close-with_msg = 关闭前要添加的评论
help-arg-pr-close-with_msg-long =
    关闭前要添加的评论

    不提供参数将打开编辑器
help-cmd-pr-browse = 在浏览器中打开合并请求
help-arg-pr-browse-id = 要在浏览器中打开的合并请求
help-cmd-pr-search = 搜索仓库的合并请求
help-arg-pr-search-state = 按状态筛选 PR。默认：open
help-arg-pr-search-repo = 要搜索的仓库
help-cmd-repo-create = 创建新仓库
help-arg-repo-create-remote = 为新仓库创建具有给定名称的新远程仓库
help-arg-repo-create-push = 将当前分支推送到新仓库的默认分支
help-arg-repo-create-push-long =
    将当前分支推送到新仓库的默认分支

    隐含 `--remote=origin`（手动设置远程将覆盖此项）
help-arg-repo-create-ssh = 为新远程仓库使用 SSH 而不是 HTTP(S)
help-cmd-repo-fork = 将仓库分叉到您的账号
help-cmd-repo-migrate = 迁移或镜像现有仓库
help-arg-repo-migrate-repo = 要迁移的仓库 URL
help-arg-repo-migrate-name = 新镜像的名称，以及可选的所属组织或用户
help-arg-repo-migrate-mirror = 是否镜像仓库而不是迁移它
help-arg-repo-migrate-private = 新迁移是否应为私有
help-arg-repo-migrate-include = 要包含的以逗号分隔的项目列表。默认为仅 git 数据
help-arg-repo-migrate-include-long =
    要包含的以逗号分隔的项目列表。默认为仅 git 数据

    这些包括 `lfs`、`wiki`、`issues`、`prs`、`milestones`、`labels` 和 `releases`。
    您可以使用 `all` 包含所有内容。
help-arg-repo-migrate-lfs_endpoint = 从中获取 LFS 文件的 URL
help-arg-repo-migrate-service = 原始仓库所在的 Git 服务类型。默认为 `git`
help-arg-repo-migrate-token = 如果启用，将从标准输入读取访问令牌以用于获取
help-arg-repo-migrate-token-long =
    如果启用，将从标准输入读取访问令牌以用于获取

    与 `--login` 互斥
help-arg-repo-migrate-login = 如果启用，将从标准输入读取用户名和密码以用于获取
help-arg-repo-migrate-login-long =
    如果启用，将从标准输入读取用户名和密码以用于获取

    与 `--token` 互斥。

    不建议使用此方法，应尽可能使用 `--token`。
help-cmd-repo-view = 查看仓库信息
help-cmd-repo-readme = 查看仓库的 README
help-cmd-repo-clone = 在本地克隆仓库代码
help-arg-repo-clone-ssh = 通过 SSH 而不是 HTTP(S) 克隆仓库
help-arg-repo-clone-identity_file = 通过 SSH 克隆时要使用的 SSH 密钥文件
help-cmd-repo-star = 为仓库点赞
help-cmd-repo-unstar = 取消仓库的点赞
help-cmd-repo-delete = 删除仓库
help-cmd-repo-delete-long =
    删除仓库

    此操作无法撤消！
help-cmd-repo-browse = 在浏览器中打开仓库页面
help-cmd-repo-labels = 管理仓库的议题标签
help-cmd-repo-labels-view = 显示仓库的标签
help-arg-repo-labels-view-archived = 显示已归档的标签
help-cmd-repo-labels-create = 创建新标签
help-arg-repo-labels-create-name = 新标签的名称。您可以在此包含 '/' 来为标签划分命名空间
help-arg-repo-labels-create-color = 新标签的颜色，十六进制格式
help-arg-repo-labels-create-description = 新标签的描述。如果未提供参数，则打开编辑器
help-arg-repo-labels-create-exclusive = 使此标签与同一命名空间中的其他标签互斥
help-arg-repo-labels-create-archived = 创建已归档的标签
help-cmd-repo-labels-delete = 删除标签
help-arg-repo-labels-delete-id = 要删除的标签的 ID 或名称
help-cmd-repo-labels-edit = 编辑标签
help-arg-repo-labels-edit-id = 要编辑的标签的 ID 或名称
help-arg-repo-labels-edit-name = 标签的新名称
help-arg-repo-labels-edit-color = 标签的新颜色
help-arg-repo-labels-edit-description = 标签的新描述。如果未提供参数，则打开编辑器
help-arg-repo-labels-edit-exclusive = 新的互斥状态
help-arg-repo-labels-edit-archived = 新的归档状态
help-cmd-repo-edit = 编辑仓库属性
help-arg-repo-edit-archived = 归档或取消归档
help-arg-repo-edit-default_branch = 设置默认分支
help-arg-repo-edit-description = 设置描述
help-arg-repo-edit-enable_prune = 镜像时移除过时的远程跟踪引用
help-arg-repo-edit-mirror_interval = 设置推送镜像的间隔。使用类似 8h30m0s 的字符串
help-arg-repo-edit-name = 设置仓库名称
help-arg-repo-edit-private = 设置此仓库的私有状态
help-arg-repo-edit-template = 设置此仓库是否为模板仓库
help-arg-repo-edit-website = 为此仓库的网站设置 URL
help-cmd-repo-units = 管理仓库的单元
help-cmd-repo-units-issues = 管理议题单元
help-arg-repo-units-issues-enable = 启用或禁用议题
help-cmd-repo-units-prs = 管理合并请求单元
help-arg-repo-units-prs-enable = 启用或禁用合并请求
help-arg-repo-units-prs-allow_fast_forward_only_merge = 允许仅快进合并
help-arg-repo-units-prs-allow_manual_merge = 允许手动合并
help-arg-repo-units-prs-allow_merge_commits = 允许合并提交
help-arg-repo-units-prs-allow_rebase = 允许变基合并
help-arg-repo-units-prs-allow_rebase_explicit = 允许使用显式合并提交进行变基合并
help-arg-repo-units-prs-allow_rebase_update = 允许通过变基更新 PR 分支
help-arg-repo-units-prs-allow_squash_merge = 允许压缩合并
help-arg-repo-units-prs-autodetect_manual_merge = 自动检测手动合并
help-arg-repo-units-prs-default_allow_maintainer_edit = 默认允许维护者编辑
help-arg-repo-units-prs-default_delete_branch_after_merge = 合并后默认删除分支
help-arg-repo-units-prs-default_merge_style = 默认合并方式
help-arg-repo-units-prs-default_update_style = 默认更新方式
help-arg-repo-units-prs-ignore_whitespace_conflicts = 忽略空白合并冲突
help-cmd-repo-units-actions = 管理操作单元
help-arg-repo-units-actions-enable = 启用或禁用操作
help-cmd-repo-units-wiki = 管理 Wiki 单元
help-arg-repo-units-wiki-enable = 启用或禁用 Wiki
help-arg-repo-units-wiki-branch = 设置 Wiki 使用的分支
help-arg-repo-units-wiki-external_url = 设置外部 Wiki 的 URL
help-arg-repo-units-wiki-external_url-long =
    设置外部 Wiki 的 URL

    如果未提供 URL，则禁用外部 Wiki。
help-arg-repo-units-wiki-globally_editable = 设置 Wiki 的全局可编辑状态
help-cmd-repo-units-packages = 管理软件包单元
help-arg-repo-units-packages-enable = 启用或禁用软件包注册表
help-cmd-repo-units-projects = 管理项目单元
help-arg-repo-units-projects-enable = 启用或禁用项目面板
help-cmd-repo-units-releases = 管理版本发布单元
help-arg-repo-units-releases-enable = 启用或禁用版本发布
help-cmd-user-search = 通过用户名搜索用户
help-arg-user-search-query = 要搜索的名称
help-cmd-user-view = 查看用户的个人资料页面
help-arg-user-view-user = 要查看的用户名称
help-arg-user-view-user-long =
    要查看的用户名称

    省略以查看您自己的页面。
help-cmd-user-browse = 在浏览器中打开用户的个人资料页面
help-arg-user-browse-user = 要在浏览器中打开的用户名称
help-arg-user-browse-user-long =
    要在浏览器中打开的用户名称

    省略以查看您自己的页面。
help-cmd-user-follow = 关注用户
help-arg-user-follow-user = 要关注的用户名称
help-cmd-user-unfollow = 取消关注用户
help-arg-user-unfollow-user = 要取消关注的用户名称
help-cmd-user-following = 列出用户关注的所有人
help-arg-user-following-user = 要列出其关注对象的用户名称
help-arg-user-following-user-long =
    要列出其关注对象的用户名称

    省略以查看您自己的关注列表。
help-cmd-user-followers = 列出用户的关注者
help-arg-user-followers-user = 要列出其关注者的用户名称
help-arg-user-followers-user-long =
    要列出其关注者的用户名称

    省略以查看您自己的关注者。
help-cmd-user-block = 屏蔽用户
help-arg-user-block-user = 要屏蔽的用户名称
help-cmd-user-unblock = 取消屏蔽用户
help-arg-user-unblock-user = 要取消屏蔽的用户名称
help-cmd-user-repos = 列出用户的仓库
help-arg-user-repos-user = 要列出其仓库的用户名称
help-arg-user-repos-user-long =
    要列出其仓库的用户名称

    省略以查看您自己的仓库。
help-arg-user-repos-starred = 列出已点赞仓库而非拥有的仓库
help-arg-user-repos-sort = 列表的排序方式
help-arg-user-repos-page = 要获取的仓库页码
help-cmd-user-orgs = 列出用户所属的组织
help-arg-user-orgs-user = 要查看其组织成员身份的用户名称
help-arg-user-orgs-user-long =
    要查看其组织成员身份的用户名称

    省略以查看您自己的组织。
help-cmd-user-activity = 列出用户的近期活动
help-arg-user-activity-user = 要查看其活动的用户名称
help-arg-user-activity-user-long =
    要查看其活动的用户名称

    省略以查看您自己的活动。
help-cmd-user-edit = 编辑您的用户设置
help-cmd-user-edit-bio = 设置您的个人简介
help-arg-user-edit-bio-content = 新的描述。省略此项将打开编辑器
help-cmd-user-edit-name = 设置您的全名
help-arg-user-edit-name-name = 新名称
help-arg-user-edit-name-unset = 从您的个人资料中移除姓名
help-cmd-user-edit-pronouns = 设置您的代词
help-arg-user-edit-pronouns-pronouns = 新的代词
help-arg-user-edit-pronouns-unset = 从您的个人资料中移除代词
help-cmd-user-edit-location = 设置您的位置
help-arg-user-edit-location-location = 新位置
help-arg-user-edit-location-unset = 从您的个人资料中移除位置
help-cmd-user-edit-activity = 设置您的活动可见性
help-arg-user-edit-activity-visibility = 您的活动的可见性
help-cmd-user-edit-email = 管理与您的账号关联的电子邮件地址
help-arg-user-edit-email-visibility = 设置您的电子邮件地址的可见性
help-arg-user-edit-email-add = 添加新的电子邮件地址
help-arg-user-edit-email-rm = 移除电子邮件地址
help-cmd-user-edit-website = 设置您的关联网站
help-arg-user-edit-website-url = 您的网站 URL
help-arg-user-edit-website-unset = 从您的个人资料中移除网站
help-cmd-user-key = 管理 SSH 密钥
help-cmd-user-key-list = 列出您的 SSH 密钥
help-arg-user-key-list-verbose = 显示每个密钥的详细信息
help-cmd-user-key-view = 查看 SSH 密钥
help-arg-user-key-view-id = 要查看的密钥 ID，如 `user key list` 中所示
help-cmd-user-key-delete = 删除 SSH 密钥
help-arg-user-key-delete-id = 要删除的密钥 ID，如 `user key list` 中所示
help-cmd-user-key-upload = 上传 SSH 密钥
help-arg-user-key-upload-keyfile = 密钥文件的路径，或 '-' 从标准输入读取。如果省略，将尝试猜测
help-arg-user-key-upload-title = 密钥的标题。如果省略，将尝试从文件内容猜测
help-arg-user-key-upload-force = 如果提供，将跳过对意外上传私钥的检查
help-arg-user-key-upload-read_only = 如果提供，新密钥将仅具有读访问权限
help-cmd-user-gpg = 管理 GPG 密钥
help-cmd-user-gpg-list = 列出您的 GPG 密钥
help-arg-user-gpg-list-verbose = 显示每个密钥的详细信息
help-cmd-user-gpg-view = 查看 GPG 密钥
help-arg-user-gpg-view-id = 要查看的 GPG 密钥 ID，如 `user gpg list` 中所示
help-cmd-user-gpg-upload = 上传 GPG 密钥
help-arg-user-gpg-upload-key = 要添加的密钥。这可以是 GPG CLI 识别的任何内容，例如与密钥关联的电子邮件或密钥 ID
help-arg-user-gpg-upload-no_verify = 跳过验证步骤。禁用此选项时，您只能添加与您的账号关联的电子邮件的密钥
help-cmd-user-gpg-verify = 验证 GPG 密钥
help-cmd-user-gpg-verify-long =
    验证 GPG 密钥

    您需要在本地安装待验证的密钥，以便用它签署一些数据。
    此命令需要安装 `gpg`。
help-arg-user-gpg-verify-id = 要验证的 GPG 密钥 ID，如 `user gpg list` 中所示
help-cmd-user-gpg-delete = 删除 GPG 密钥。这将取消验证使用该密钥签署的所有提交！
help-arg-user-gpg-delete-id = 要删除的 GPG 密钥 ID，如 `user gpg list` 中所示
help-arg-user-gpg-delete-force = 不要求确认
help-cmd-release-create = 创建新版本发布
help-arg-release-create-create_tag = 为此版本发布创建新的对应标签。默认为版本发布的名称
help-arg-release-create-tag = 要使用的现有标签
help-arg-release-create-tag-long =
    要使用的现有标签

    如果您需要为此版本发布创建新标签，请使用 `--create-tag`
help-arg-release-create-attach = 包含文件作为附件
help-arg-release-create-attach-long =
    包含文件作为附件

    `--attach=<FILE>` 将把附件名称设置为文件名
    `--attach=<FILE>:<ASSET>` 将使用提供的名称作为附件
help-arg-release-create-body = 版本发布正文
help-arg-release-create-body-long =
    版本发布正文

    使用此标志但不提供参数将打开编辑器。
help-cmd-release-edit = 编辑版本发布信息
help-arg-release-edit-tag = 此版本发布对应的标签
help-arg-release-edit-body = 版本发布正文
help-arg-release-edit-body-long =
    版本发布正文

    使用此标志但不提供参数将打开编辑器。
help-cmd-release-delete = 删除版本发布
help-cmd-release-list = 列出仓库上的所有版本发布
help-cmd-release-view = 查看版本发布信息
help-cmd-release-browse = 在浏览器中打开版本发布
help-cmd-release-asset = 对版本发布附件文件的命令
help-cmd-release-asset-create = 在版本发布上创建新附件
help-cmd-release-asset-delete = 从版本发布移除附件
help-cmd-release-asset-download = 下载附件文件
help-cmd-release-asset-download-long =
    下载附件文件

    使用 `source.zip` 或 `source.tar.gz` 下载仓库归档
help-cmd-tag-create = 创建新标签
help-arg-tag-create-body = 标签消息的文本
help-arg-tag-create-body-long =
    标签消息的文本

    使用此标志但不提供参数将打开编辑器。
help-cmd-tag-delete = 删除标签
help-cmd-tag-list = 列出仓库上的所有标签
help-cmd-tag-view = 查看标签信息
help-arg-version-check = 检查更新
help-arg-wiki-clone-ssh = 通过 SSH 而不是 HTTP(S) 克隆仓库
help-arg-wiki-clone-identity_file = 通过 SSH 克隆时要使用的 SSH 密钥文件
-bullet =
    { IS_MINIMAL() ->
        [yes] -
       *[no] •
    }
msg-repo_not_found = 找不到指定的仓库
help-cmd-issue-view-assignees = 列出分配给此议题的用户
msg-view-assignees-header = 分配给（{ $count } 名用户）：
msg-view-assignees-entry =
    { OPT($full_name) ->
       *[none] { -bullet } { $login }
        [some] { -bullet } { $full_name } { STYLE("dark-grey") }({ $login }){ STYLE("reset") }
    }
msg-view-assignees-empty = 没有人被分配。
help-cmd-issue-depend = 管理此议题所依赖的议题
help-cmd-issue-block = 管理此议题阻止的议题
help-cmd-depend-add = 添加一个或多个依赖
help-cmd-depend-remove = 移除一个或多个依赖
help-cmd-depend-list = 列出依赖
help-cmd-block-add = 添加一个或多个阻止关系
help-cmd-block-remove = 移除一个或多个阻止关系
help-cmd-block-list = 列出阻止项
help-arg-depend-add-target = 要作为依赖添加的一个或多个议题
help-arg-depend-remove-target = 要从依赖中移除的一个或多个议题
help-arg-block-remove-target = 要取消阻止的一个或多个议题
help-arg-issue-depend-add-issue = 要操作的议题
help-arg-issue-depend-remove-issue = 要操作的议题
help-arg-issue-depend-list-issue = 要列出其依赖的议题
help-arg-issue-block-add-issue = 要操作的议题
help-arg-issue-block-add-target = 此议题应阻止的一个或多个议题
help-arg-issue-block-remove-issue = 要操作的议题
help-arg-issue-block-list-issue = 要列出其阻止项的议题
msg-issue-depend-add-success = 已向 #{ $issue } 添加 { $count } 个依赖
msg-issue-depend-remove-success = 已从 #{ $issue } 移除 { $count } 个依赖
msg-issue-block-add-success = 已从 #{ $issue } 添加 { $count } 个阻止关系
msg-issue-block-remove-success = 已从 #{ $issue } 移除 { $count } 个阻止关系
msg-issue-dep-target-required = 至少需要一个目标议题
msg-issue-depend-no_repo_info = 无法确定要访问哪个仓库，请尝试在议题或目标参数中通过 `{{ owner }}/{{ repo }}#{{ number }}` 指定
msg-pr-depend-no_repo_info = 无法确定要访问哪个仓库，请尝试使用 `--repo` 指定
msg-issue-depend-list-empty = 没有依赖。
msg-issue-block-list-empty = 没有阻止项。
msg-issue-depend-list-header = { STYLE("bold") }{ $owner }/{ $repo } 的依赖{ STYLE("reset") } { -dash } #{ $number }
msg-issue-block-list-header = { STYLE("bold") }被 { $owner }/{ $repo } 阻止的议题{ STYLE("reset") } { -dash } #{ $number }
msg-issue-dep-list-entry =
    { "  " }#{ $number } { STYLE("bold") }{ $title }{ STYLE("reset") } ({ $state ->
        [closed] 已关闭
        [merged] 已合并
        [draft] 草稿
       *[open] 打开
    })
help-cmd-pr-view-assignees = 列出分配给此合并请求的用户
help-cmd-pr-depend = 管理此合并请求所依赖的议题
help-cmd-pr-block = 管理此合并请求阻止的议题
help-arg-pr-depend-add-pr = 要操作的合并请求
help-arg-pr-depend-remove-pr = 要操作的合并请求
help-arg-pr-depend-list-pr = 要列出其依赖的合并请求
help-arg-pr-block-add-pr = 要操作的合并请求
help-arg-pr-block-add-target = 此合并请求应阻止的一个或多个议题
help-arg-pr-block-remove-pr = 要操作的合并请求
help-arg-pr-block-list-pr = 要列出其阻止项的合并请求
help-cmd-repo-star_status = 检查您当前的点赞状态
help-arg-repo-star_status-list = 列出所有已点赞的仓库，而不是检查状态
msg-repo-star-already_starred = 您已为此仓库点赞
msg-repo-unstar-already_unstarred = 您尚未为此仓库点赞
msg-repo-star_status-starred = 您已点赞 { $owner }/{ $repo }
msg-repo-star_status-unstarred = 您尚未点赞 { $owner }/{ $repo }
msg-repo-star_status-list-header = 您点赞了 { $count } 个仓库
msg-repo-star_status-list-repo = 已点赞 { $owner }/{ $repo }
help-arg-repo-edit-avatar = 要设置为仓库头像的图片路径
help-arg-repo-edit-unset_avatar = 移除仓库当前设置的头像
msg-repo-edit-avatar_file_not_found = { $path } 不存在。
msg-auth-login-oauth-login-open-fail = 由于错误，无法处理 OAuth 登录
msg-repo-watch-success = 您现在正在关注 { $owner }/{ $repo }
msg-repo-watch-already_subscribed = 您已关注此仓库
msg-repo-unwatch-already_unsubscribed = 您尚未关注此仓库
msg-repo-unwatch-success = 您不再关注 { $owner }/{ $repo }
msg-repo-watch_status-subscribed = 您已订阅 { $owner }/{ $repo }
msg-repo-watch_status-unsubscribed = 您尚未订阅 { $owner }/{ $repo }
msg-repo-watch_status-list-header = 您已订阅 { $count } 个仓库
msg-repo-watch_status-list-repo = 已订阅 { $owner }/{ $repo }
help-cmd-repo-watch = 订阅一个仓库
help-cmd-repo-unwatch = 取消订阅一个仓库
help-cmd-repo-watch_status = 检查您当前的关注状态
help-arg-repo-watch_status-list = 列出所有已关注的仓库，而不是检查状态
help-arg-cwd = 将工作目录设置为 <CWD>
msg-project-dir-not-found = 找不到 forge 的项目目录
msg-old-key-file-read =
    注意：正在从旧位置的密钥文件中读取。
        该位置已弃用。密钥文件将保存到新位置。
msg-save-migrated-key-file-fail =
    { STYLE("bold", "yellow") }无法将密钥文件迁移到新位置！
    请确保 forge 可以写入 { $path }。旧文件未被修改。{ STYLE("reset") }
