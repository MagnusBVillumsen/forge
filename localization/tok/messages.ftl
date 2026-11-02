msg-whoami = sina kepeken sijelo { $name }@{ $host }
msg-auth-login-oauth_unsupported =
    ilo FJ sina li ken ala kepeken nasin `login` lon ma { $host_domain }

    o lukin e lipu { $applications_url }
    o pali e nimi len ilo, o pana e ona tawa mi kepeken `forge auth add-key`
msg-auth-login-canceled = sina kama ala lon sijelo
msg-auth-login-browser_success = sina kama lon sijelo! o weka lipu ni, o tawa ilo toki sina
msg-auth-login-browser_failure = pakala li lon la sina ken ala kama lon sijelo
msg-auth_logout-success = sina weka tan sijelo { $host }
msg-auth_logout-already_signed_out = sina kepeken ala sijelo pi ma { $host }
msg-auth-use_ssh-not_logged_in = sina kepeken ala sijelo pi ma { $host } la mi ken ala ni
msg-auth-use_ssh-enabled = ma { $host } la mi kama jo e toki ilo la mi kama kepeken nasin SSH
msg-auth-use_ssh-disabled = ma { $host } la mi kama jo e toki ilo la mi kama kepeken ala nasin SSH
msg-auth-use_ssh-already_enabled = ma { $host } la mi kama jo e toki ilo la mi awen kepeken nasin SSH
msg-auth-use_ssh-already_disabled = ma { $host } la mi kama jo e toki ilo la mi awen kepeken ala nasin SSH
msg-auth-add_token-prompt = nimi len ilo sin:
msg-auth-add_token-already_exists = mi ken ala ni. nimi len ilo pi ma { $host } li lon
msg-auth-list-none = sina kepeken sijelo ala
msg-actions-variable-create-already_exists = sona ni li lon. sina wile ante e ona la, o kepeken nimi `--force`
msg-actions-variable-create-already_exists_forced = sona ni li lon. mi ante e ona
msg-actions-variable-delete-success = sona { $name } li weka
msg-org-list-no_results = alasa ni la kulupu ala li lon
msg-org-list-page_number = ni li kulupu nanpa { $page }. kulupu { $total } li lon
msg-org-view-org_name =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }kulupu { $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }kulupu { $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    }
msg-org-view-visibility =
    { $visibility ->
        [public] ale li ken lukin
        [limited] jan pi ma ni taso li ken lukin
       *[private] jan pi kulupu ni taso li ken lukin
    }
msg-org-view-member_count = jan { STYLE("bold") }{ $member_count }{ STYLE("reset") } li lon ni
msg-org-view-team_count = kulupu { STYLE("bold") }{ $team_count }{ STYLE("reset") } li lon ni
msg-org-create-invalid_character =
    sitelen pi nimi kulupu li ken ni taso: sitelen Lasina anu sitelen nanpa anu sitelen `-` anu sitelen `_` anu sitelen `.`
      sina wile kepeken sitelen ante la o kepeken nimi `--full-name`
msg-org-create-invalid_starting_character =
    sitelen open pi nimi kulupu li ken sitelen Lasina taso
      sina wile kepeken sitelen ante la o kepeken nimi `--full-name`
msg-org-create-invalid_ending_character =
    sitelen pini pi nimi kulupu li ken ni taso: sitelen Lasina anu sitelen nanpa
      sina wile kepeken sitelen ante la o kepeken nimi `--full-name`
msg-org-create-invalid_consecutive_characters =
    nimi kulupu la sitelen ni li ken ala lon poka sitelen sama: anu sitelen `-` anu sitelen `_` anu sitelen `.`
      sina wile kepeken ni la o kepeken nimi `--full-name`
msg-org-create-success =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }kulupu { $name }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }kulupu { $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $name }){ STYLE("reset") }
    } li kama lon. { $visibility ->
        [public] ale li ken lukin e ona
        [limited] jan pi ma ni taso li ken lukin e ona
       *[private] jan pi kulupu ni taso li ken lukin e ona
    }
msg-org-members-no_results = alasa ni la jan ala li lon
msg-org-members-page_number = ni li kulupu nanpa { $page }. kulupu { $total } li lon
msg-org-members-entry =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") }
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("light-gray") }({ $username }){ STYLE("reset") }
    }
msg-org-visibility-public = sona ni li len ala: sina lon kulupu { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-private = sona ni li len: sina lon kulupu { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_public = sona ni li kama len ala: sina lon kulupu { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-set_private = sona ni li kama len: sina lon kulupu { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-visibility-not_member = sina lon ala kulupu { STYLE("bold", "bright-cyan") }{ $org_name }{ STYLE("reset") }
msg-org-label-add-success = poki toki sin { $label } li kama lon
msg-org-label-edit-success = poki toki { $old_label } li kama poki { $label }
msg-org-label-remove-success = poki toki { $label } li weka
msg-org-repo-list-no_results = alasa ni la poki ala li lon
msg-org-repo-list-page_number = ni li kulupu nanpa { $page }. kulupu { $total } li lon
msg-org-team-view =
    { STYLE("bright-blue", "bold") }kulupu { $name }{ STYLE("reset") } pi { STYLE("bold") } kulupu { $org }{ STYLE("reset") } { $admin ->
        [yes] { -dash } { STYLE("bright-red") }ona li ken lawa e kulupu{ STYLE("reset") }
       *[no] { "" }
    }
msg-org-team-view-read_only = ona li ken lukin taso e ni:
msg-org-team-view-read_write = ona li ken ante e ni:
msg-org-team-create-success =
    { STYLE("bright-blue", "bold") }kulupu { $admin ->
        [yes] lawa
       *[no] { "" }
    } { $name }{ STYLE("reset") } li kama lon { STYLE("bold") }kulupu { $org }{ STYLE("reset") }
msg-org-team-delete-confirmation = sina wile ala wile weka e { STYLE("bold") }kulupu { $name }{ STYLE("reset") } tan kulupu { $org }?
    .yes =
        wile
        w
    .no =
        wile ala
        ala
        a
msg-org-team-repo-list-no_results = alasa ni la kulupu ala li lon
msg-org-team-repo-list-page_number = ni li kulupu nanpa { $page }. kulupu { $total } li lon
msg-org-team-repo-add-success = { STYLE("bold", "bright-blue") }kulupu { $team }{ STYLE("reset") } li kama mama e { STYLE("bold") } poki { $org }/{ $repo }{ STYLE("reset") }
msg-org-team-repo-rm-success = { STYLE("bold", "bright-blue") }kulupu { $team }{ STYLE("reset") } li kama mama ala e { STYLE("bold") } poki { $org }/{ $repo }{ STYLE("reset") }
msg-org-team-member-list-no_results = alasa ni la jan ala li lon
msg-org-team-member-list-page_number = ni li kulupu nanpa { $page }. kulupu { $total } li lon
msg-org-team-member-add-success = { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } li kama lon { STYLE("bold", "bright-blue") }kulupu { $team }{ STYLE("reset") }
msg-org-team-member-rm-success = { STYLE("bold", "bright-cyan") }{ $user }{ STYLE("reset") } li weka tan { STYLE("bold", "bright-blue") }kulupu { $team }{ STYLE("reset") }
msg-issue-create-success = sina open e toki nanpa { $number }: { $title }
msg-issue-view-header =
    toki { STYLE("yellow") }"{ $title }"{ STYLE("dark-grey") } li nanpa { $number }{ STYLE("reset") }
    li tan { STYLE("white") }{ $author }{ STYLE("reset") } li { $state ->
        [open] { STYLE("bright-green") }pini ala{ STYLE("reset") }
        [closed] { STYLE("bright-red") }pini{ STYLE("reset") }
       *[other] $state
    }
msg-issue-view-comment_count = toki { $comments } li lon toki ni
msg-issue-templates-blank_allowed = nimi "--no-template" li ken
msg-issue-templates-blank_not_allowed = nimi "--no-template" li ken ala
msg-issue-search-entry = toki "{ $title }" li nanpa { $number } li tan { $author }
msg-issue-view-comments-comment_header =
    { OPT($full_name) ->
       *[none] { STYLE("bold", "bright-cyan") }{ $username }{ STYLE("reset") } li toki e ni:
        [some] { STYLE("bold", "bright-cyan") }{ $full_name }{ STYLE("reset") } { STYLE("dark-gray") }({ $username }){ STYLE("reset") } li toki e ni:
    }
msg-issue-view-comments-attachments = ijo { $attachments } li lon toki ni
msg-repo-view-url = o lukin e ona lon { $url }
msg-repo-readme-none = poki ni li jo ala e lipu "README"
msg-issue-edit-title-empty = nimi li ken ala jo e sitelen ala
msg-issue-edit-title-no_newlines = nimi o jo e linja wan taso
msg-repo-clone-preparing = { "     " }mi open...
msg-repo-clone-downloading = { "  " }mi kama jo... { NUMBER($percent, maximumFractionDigits: 2) }% ({ NUMBER($size, maximumFractionDigits: 2) }{ $units })
msg-repo-clone-resolving = { "" }mi kama sona... { NUMBER($percent, maximumFractionDigits: 2) }%
msg-repo-clone-finishing_up = { "     " }mi pini...
msg-repo-clone-success = poki weka { $repo } li kama lon poki poka { $path }
msg-repo-delete-confirmation_prompt = sina wile ala wile weka e poki { $owner }/{ $name }?
    .yes =
        wile
        w
    .no =
        wile ala
        ala
        a
msg-repo-delete-success = { $owner }/{ $repo } li weka
msg-repo-delete-cancelled = ona li weka ala
msg-repo-label-view-archived = (majuna)
msg-repo-label-view-no_description = (toki ala)
msg-repo-label-create-success = poki toki { $label } li kama lon
msg-repo-label-delete-success = poki toki { $label } li kama weka
msg-repo-label-edit-success = poki toki { $label } li kama ante
msg-user-search-page_zero = kulupu nanpa 0 li lon ala
msg-user-search-fail = alasa li pakala
msg-user-view-joined_on = ona li kama lon ma ni lon { STYLE("bold") }tenpo { DATETIME($joined, dateStyle: "medium") }{ STYLE("reset") }
msg-user-follow-success = sina lukin e { $username }
msg-user-unfollow-success = sina lukin ala e { $username }
msg-user-following-none-other = { $user } li lukin e jan ala
msg-user-following-none-self = sina lukin e jan ala
msg-user-following-other = { $user } li lukin e ni:
msg-user-following-self = sinai lukin e ni:
msg-user-followers-none-other = jan ala li lukin e { $user }
msg-user-followers-none-self = jan ala li lukin e sina :(
msg-user-followers-other = jan ni li lukin e { $user }:
msg-user-followers-self = jan ni li lukin e sina:
msg-user-block-success = sina weka e { $user } tan lukin sina
msg-user-unblock-success = sina weka ala e { $user } tan lukin sina
msg-user-repos-none-other = { $name } li jo ala e poki
msg-user-repos-none-self = sina jo ala e poki
msg-user-orgs-none-other = { $user } li lon kulupu ala
msg-user-orgs-none-self = sina lon kulupu ala
msg-user-orgs-count = kulupu { $organizations }
-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
msg-org-team-view-perms-wiki = lipu sona
msg-org-team-view-perms-ext_wiki = lipu sona pi ma ante
msg-org-team-view-perms-issues = toki
msg-org-team-view-perms-ext_issues = toki pi ma ante
msg-org-team-view-perms-pulls = ante wile
msg-org-team-view-perms-projects = sinpin pali
msg-org-team-view-perms-code = toki ilo
msg-org-team-view-perms-releases = pana
msg-org-team-view-perms-packages = pana poki
msg-issue-create-no_templates = poki { $owner }/{ $repo } li kepeken ala nasin toki
msg-issue-create-templates_required =
    poki { $owner }/{ $repo } la o kepeken nasin toki
    sina ken kepeken ona kepeken nimi `--template <NIMI>`
msg-issue-create-templates_enabled =
    poki { $owner }/{ $repo } li kepeken nasin toki
    sina ken kepeken ona kepeken nimi `--template <NIMI>`
    anu ken kepeken ala ona kepeken nimi `--no-template`
msg-issue-templates-none = nasin toki ala li lon poki ni
msg-issue-close-success = sina pini e toki nanpa { $number }: { $title }
msg-pr-couldnt_guess = mi sona ala e nanpa pi ante wile. o pana e nanpa
msg-pr-not_found = mi sona ala e ante wile ni
msg-pr-view-header =
    { STYLE("yellow") }ante wile "{ $title }" { STYLE("dark-grey") } li { $number }{ STYLE("reset") }
    li tan { STYLE("white") }{ $username }{ STYLE("reset") } { $state ->
        [draft] { STYLE("light-grey") }. ante li pini ala{ STYLE("reset") }
        [open] { STYLE("bright-green") }li pini ala{ STYLE("reset") }
        [merged] { STYLE("bright-magenta") }. ante li tawa mama ona{ STYLE("reset") }
        [closed] { STYLE("bright-red") }li pini{ STYLE("reset") }
       *[other] $state
    } { -dash } { STYLE("bright-green") }linja { $additions } li kama { STYLE("reset") }, { STYLE("bright-red") }linja { $deletions } li weka{ STYLE("reset") }
    { OPT($head_branch) ->
       *[none] ante li tawa `{ $base_branch }`
        [some] ante li kama tan `{ $head_branch }` li tawa `{ $base_branch }`
    }
msg-pr-view-comment_count = { $comments } toki li lon ante wile ni
msg-pr-status-merged = { STYLE("bright-magenta") }ante li tawa mama ona{ STYLE("reset") }. { $merged_by } li wan e ona lon tenpo { DATETIME($merged_at, dateStyle: "long", timeStyle: "long") }
msg-pr-status-header =
    { $state ->
        [draft] { STYLE("light-grey") }ona li sin{ STYLE("reset") } { -dash } la sina ken ala wan e ona
        [open]
            { STYLE("bright-green") }ona li pini ala{ STYLE("reset") } { $mergeable ->
               *[yes] li ken kama wa
                [no] { STYLE("bright-red") } li ken ala kama wan{ STYLE("reset") }
            }
        [closed] { STYLE("bright-red") }ona li pini{ STYLE("reset") } { -dash } sina wile wan e ona la o open sin e ona
       *[other] nasa
    }
msg-pr-status-entry =
    { $state ->
        [success] { STYLE("bright-green") }pona{ STYLE("reset") }
        [pending] { STYLE("yellow") }open ala{ STYLE("reset") }
        [warning] { STYLE("bright-yellow") }ike ken { STYLE("reset") }
        [failure] { STYLE("bright-red") }ike{ STYLE("reset") }
        [error] { STYLE("bright-red") }pakala{ STYLE("reset") }
       *[other] nasa
    } { -dash } { $context }
msg-pr-create-cross_instance = ante wile o lon ma wan taso; mama li lon ma { $base_instance }, taso ante li lon ma { $head_instance }
msg-pr-create-success = sina open e ante wile nanpa { $number }: { $title }
msg-pr-create-agit_success = sina open e ante wile: { $title }
msg-pr-create-agit_push_cfg_question =
    sina wile ala wile e ni:
    nasin pi ilo Git li ante tawa ni: nasin `git push` li ken, lon ante wile ni
msg-pr-create-agit_push_cfg_prompt = (w/A/?)
    .yes =
        wile
        w
    .no =
        wile ala
        ala
        a
    .help =
        seme
        s
        ?
msg-pr-create-agit_force_push_warning =
    { STYLE("bold") }o sona e ni:{ STYLE("reset") }
      nasin AGit la `git push --force[-with-lease]` li ken ala.
      o kepeken nasin `git push -o force=true`.
msg-pr-create-agit_push_cfg_help = ni li ante e nasin ni:
msg-pr-merge-default_message = Reviewed-on: { $pr_url }
msg-pr-merge-success = ante wile nanpa { $number } \"{ $title }\" li kama tawa `{ $base_branch }`
msg-pr-checkout-dirty = ante pi awen ala li lon poka la mi ken ala lukin e ante wile ni
msg-pr-checkout-not_fork = poki { $repo } li jo ala e poki mama
msg-pr-search-entry = ante wile "{ $title }" li nanpa { $number } li tan { $author }
msg-repo-fallback_host-invalid_url = o sona: `FJ_FALLBACK_HOST` li pakala
msg-repo-arg_no_owner = nimi poki o kepeken nasin nimi ni: [MA/]JAN/POKI anu [MA/]KULUPU/POKI
msg-wiki-clone-success = lipu sona pi poki { $repo } li kama lon poki poka { $path }
msg-version-update_check-behind =
    sin pi ilo FJ li lon: nanpa { $new_version }
    o kama jo e ona lon lipu { $url }
msg-version-update_check-current = sin pi ilo FJ li lon ala. wawa a!
msg-version-update_check-hint = sina ken alasa e sin pi ilo FJ kepeken nimi`forge version --check`
msg-release-asset-delete-success = ijo { $asset } li weka tan pana { $release }
msg-release-asset-create-success = ijo { $asset } li kama lon pana { $release }
msg-release-view-header =
    pana { $name }
    tan { $author } lon tenpo { DATETIME($created_at, dateStyle: "long") }
msg-release-create-success = sina open e pana { $name }
msg-release-create-tag_flags_conflict = sina ken ala kepeken nimi `--tag` kepeken nimi `--create-tag`. o kepeken ni wan taso.
msg-release-create-must_specify_tag = o kepeken nimi `--tag` anu nimi `--create-tag`
msg-user-gpg-delete-success = nimi GPG nanpa { $id } li weka
msg-user-gpg-delete-unconfirmed = ni li weka ala
msg-user-gpg-upload-success = nimi GPG li pana!
msg-user-gpg-upload-export_failed =
    mi ken ala pana e nimi GPG tawa ilo Forgejo. { OPT($status_code) ->
       *[none] { "" }
        [some] pakala pi nasin GPG li ni: { $status_code }
    }
msg-user-gpg-upload-exporting = mi pana e nimi GPG
msg-user-gpg-list-subkey = { STYLE("bold") }nimi { STYLE("bright-magenta") } nanpa { $id }{ STYLE("reset") }:
msg-user-gpg-list-can_encrypt_storage =
    { STYLE("bold") }ni li ken ala ken len e ijo:{ STYLE("reset") }  { $can_encrypt_storage ->
        [yes] { STYLE("bright-green") }ken{ STYLE("reset") }
       *[no] { STYLE("bright-red") }ken ala{ STYLE("reset") }
    }
msg-user-gpg-list-can_encrypt_comms =
    { STYLE("bold") }ni li ken ala ken len e toki:{ STYLE("reset") } { $can_encrypt_storage ->
        [yes] { STYLE("bright-green") }ken{ STYLE("reset") }Updated branch to latest commit
       *[no] { STYLE("bright-red") }ken ala{ STYLE("reset") }
    }
msg-user-gpg-list-key_id = { STYLE("bold") }nanpa pi nimi ni:{ STYLE("reset") }            { STYLE("bright-cyan") }{ $key_id }{ STYLE("reset") }
msg-user-gpg-list-header = { STYLE("bold") }nimi GPG { STYLE("bright-magenta") } nanpa { $id }{ STYLE("reset") }
msg-user-gpg-list-count = nimi { $keys } li lon
msg-user-key-add-success = nimi SSH li pana!
msg-user-key-upload-confirm_key_title_prompt =
    nimi lukin ona li ken ni: { STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
    sina wile ala wile e nimi ni?
    .yes =
        wile
        w
    .no =
        wile ala
        ala
        ala
        a
msg-user-key-add-invalid_key =
    ken la ijo '{ $path }' li nimi len anu ijo pakala
     sina awen wile ni la o kepeken nimi `--force`
msg-user-key-add-unexpected_extension =
    pini pi nimi '{ $path }' li nimi '.pub' ala. ni li nimi len anu seme?
     sina awen wile ni la o kepeken nimi `--force`
msg-user-key-upload-confirm_key_file_prompt =
    mi lukin e nimi SSH ni: { $path }
    mi o pana ala pana e ona?
    .yes =
        pana
        p
    .no =
        pana ala
        ala
        a
msg-user-key-upload-keys_not_found = mi ken ala lukin e nimi SSH
msg-user-key-delete-success = nimi SSH nanpa { $id } li weka
msg-user-edit-website-removal_hint = sina wile weka e lipu linluwi sina tan lipu Forgejo sina la o kepeken nimi `--unset`
msg-user-edit-location-removal_hint = sina wile weka e nimi pi ma sina tan lipu sina la o kepeken nimi `--unset`
msg-user-edit-pronouns-removal_hint = sina wile weka e nimi sina pi sama nimi "ona" tan lipu sina la o kepeken nimi `--unset`
msg-user-edit-name-removal_hint = sina wile weka e nimi sina tan lipu sina la o kepeken nimi `--unset`
msg-activity-created_release = { STYLE("bold") }{ $actor }{ STYLE("reset") } li open e pana { STYLE("bold", "bright-cyan") }{ $release_name }{ STYLE("reset") } lon poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-commented_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } li toki lon ante wile { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-rejected_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } li pana e ante ken tawa ante wile { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-deleted_branch = { STYLE("bold") }{ $actor }{ STYLE("reset") } li weka e linja { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } tan poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-deleted_tag = { STYLE("bold") }{ $actor }{ STYLE("reset") } li weka e kule { STYLE("bold", "bright-cyan") }{ $tag_name }{ STYLE("reset") } tan poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-reopened_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } li open sin e ante wile { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-closed_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } li pini e ante wile { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-reopened_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } li open sin e toki { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-closed_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } li pini e toki { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-merged_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } li wan e ante wile { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-commented_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } li toki lon toki { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-transferred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } li tawa e poki { STYLE("bold", "yellow") }\"{ $old_name }\"{ STYLE("reset") } tawa poki { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") }
msg-activity-created_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } li open e ante wile { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-created_issue = { STYLE("bold") }{ $actor }{ STYLE("reset") } li open e toki { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") }
msg-activity-pushed_commit = { STYLE("bold") }{ $actor }{ STYLE("reset") } li pana lon linja { STYLE("bold", "bright-cyan") }{ $branch }{ STYLE("reset") } lon poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-watched_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } li lukin e poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-starred_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } li pilin pona tawa poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-renamed_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } li ante e nimi pi poki { STYLE("bold", "yellow") }\"{ $old_name }\"{ STYLE("reset") } tawa nimi { STYLE("bold", "yellow") }{ $new_name }{ STYLE("reset") }
msg-activity-created_repo = { STYLE("bold") }{ $actor }{ STYLE("reset") } li open e poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_mirror = { STYLE("bold") }{ $actor }{ STYLE("reset") } li open e jasima { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-activity-created_fork = { STYLE("bold") }{ $actor }{ STYLE("reset") } li kipisi e poki { STYLE("bold", "yellow") }{ $parent_repo_name }{ STYLE("reset") } tawa poki { STYLE("bold", "yellow") }{ $repo_name }{ STYLE("reset") }
msg-user-view-header =
    { STYLE("bright-cyan", "bold") }{ $username }{ STYLE("reset") } { OPT($pronouns) ->
       *[none] { "" }
        [some] { STYLE("light-grey") } { -dash } { STYLE("bold") }{ $pronouns }{ STYLE("reset") }
    }
    jan { STYLE("bold") }{ $followers }{ STYLE("reset") } li lukin e ona { -dash } ona li lukin e jan { STYLE("bold") }{ $following }{ STYLE("reset") }
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
msg-repo-view-external_tracker = toki li lon lipu { $url }
msg-repo-view-name = poki { $repo_name }
msg-repo-view-is_fork = poki { $parent } li mama ona
msg-repo-view-is_mirror = ona li jasima e poki { $mirror_of }
msg-repo-view-primary_language = toki wan ona li toki { $language }
msg-repo-view-stars = pona tawa jan { $stars }
msg-repo-view-watching = jan { $watching } li lukin e ona
msg-repo-view-forks = ona li mama tawa poki { $forks }
msg-repo-view-issues = toki { $issues } li lon ona
msg-repo-view-prs = ante wile { $pull_requests } li lon ona
msg-repo-view-releases = pana { $releases } li lon ona
msg-repo-migrate-success = wawa! o lukin e ona lon lipu { $url }
msg-repo-migrate-migrating = mi tawa e ona...
msg-repo-migrate-token_prompt = nimi len ilo:
msg-repo-migrate-password_prompt = nimi len:
msg-repo-migrate-username_prompt = nimi sijelo:
msg-repo-fork-success = sina kipisi e poki { $parent_owner }/{ $parent_name } tawa poki { $fork_name }
msg-repo-create-branch_invalid_utf8 = nimi linja o kepeken nasin sitelen UTF-8
msg-repo-create-detached_head = awen 'HEAD' li lon ala linja la mi ken ala pana
msg-repo-create-success = poki sina li open lon lipu { $url }
msg-repo-name_needed = mi ken ala kama sona e nimi poki. o pana e nimi ni
msg-pr-checkout-success =
    sina lon ante wile nanpa #{ $number }: "{ $title }"
    { $new_branch ->
       *[yes] sina lon linja sin { $branch_name }
        [no] linja li kama sin
    }
msg-issue-assign-success =
    jan { $added } sin o pali e toki { $owner }/{ $repo }#{ $number } { $duplicate ->
        [0] { "" }
        [one]
            { $added ->
                [0] (ona li awen ni)
               *[other] (jan 1 li awen ni)
            }
       *[other]
            { $added ->
                [0] (jan ale li awen ni)
               *[other] (jan { $duplicate } li awen ni)
            }
    }
msg-issue-unassign-success =
    jan { $removed } o pali ala e toki { $owner }/{ $repo }#{ $number } { $duplicate ->
        [0] { "" }
        [one]
            { $removed ->
                [0] (ona li awen ni)
               *[other] (jan 1 li awen ni)
            }
       *[other]
            { $added ->
                [0] (jan ale li awen ni)
               *[other] (jan { $duplicate } li awen ni)
            }
    }
msg-pr-review-list-none = ala li pana e pilin ona pi ante ni.
msg-pr-review-list-only_stale = pilin ale li pini anu majuna. sina wile lukin e ona la o kepeken nimi `--all`
msg-pr-review-list-review_header =
    { STYLE("bold") }{ $reviewer }{ STYLE("reset") }{ $review_type ->
        [approved] la { STYLE("bright-green") }ni li pona{ STYLE("reset") }
        [changes-requested] la { STYLE("bright-yellow") }ni o ante{ STYLE("reset") }
        [comment] li { STYLE("bright-yellow") }toki{ STYLE("reset") }
        [pending] li { STYLE("light-grey") }alasa toki e pilin ona{ STYLE("reset") }
       *[other] Unknown
    }
    { STYLE("dark-grey") }toki { $comments } li lon ni. ni li open lon tenpo { DATETIME($timestamp, dateStyle: "long", timeStyle: "short") }{ STYLE("reset") }. { $state ->
        [stale] { STYLE("bold") }(ni li majuna){ STYLE("reset") }
        [dismissed] { STYLE("bold") }(ni li pini){ STYLE("reset") }
       *[other] { "" }
    }
msg-pr-review-list-comment_position = lon lipu { STYLE("bold") }{ $path }{ STYLE("reset") } lon linja nanpa { STYLE("bold") }{ $position }{ STYLE("reset") }:
msg-pr-review-list-comment_header =
    { STYLE("bold", "bright-cyan") }{ $commenter }{ STYLE("reset") } li toki e ni { OPT($resolver) ->
       *[none] { "" }
        [some] ({ $resolver } li pini e ni)
    }:
msg-pr-merge-commit_title_unsupported-rebase = nasin 'rebase' la sina ken ala pana e toki open lon awen pi ilo Git
msg-pr-merge-commit_title_unsupported-ff = nasin 'ff-only' la sina ken ala pana e toki open lon awen pi ilo Git
msg-pr-merge-commit_title_unsupported-manual = nasin 'manually merged' la sina ken ala pana e toki open lon awen pi ilo Git
msg-pr-view-diff-volatile = sina ante e lipu ante la ante sina li awen ala
msg-repo-migrate-git_only = nasin Git taso la sina kama e poki la sina ken kama e ijo lon poki taso e ijo lon nasin LFS taso. sina ken ala kama e ijo ante pi poki ni. o kepeken e nasin kama ante, anu weka e nimi pi ken ala
msg-repo-star-success = sina pana e sona ni: poki { $owner }/{ $repo } li pona tawa sina!
msg-repo-unstar-success = sina weka e pilin pona tan poki { $owner }/{ $repo }
msg-user-search-none = alasa ni la jan ala li lon
msg-user-search-footer =
    alasa la kulupu ni li tan { STYLE("bold") }jan nanpa { $first_index } tawa jan nanpa { $last_index }{ STYLE("reset") }. ale la jan { STYLE("bold") }{ $total_results }{ STYLE("reset") } li lon
    ni li kulupu nanpa { $page }. kulupu { $total_pages } li lon
    { $more ->
        [yes] sina wile lukin e kulupu ante la o kepeken e nimi `--page`
       *[no] { "" }
    }
msg-user-repos-none-starred-other = { $name } li pana ala e pilin pona poki
msg-user-repos-none-starred-self = sina pana ala e pilin pona poki
msg-user-repos-list_footer =
    alasa la kulupu ni li tan { STYLE("bold") }poki nanpa { $first_index } tawa poki nanpa { $last_index }{ STYLE("reset") }. ale la poki { STYLE("bold") }{ $total_results }{ STYLE("reset") } li lon
    ni li kulupu nanpa { $page }. kulupu { $total_pages } li lon
    { $more ->
        [yes] sina wile lukin e kulupu ante la o kepeken e nimi `--page`
       *[no] { "" }
    }
msg-activity-approved_pr = { STYLE("bold") }{ $actor }{ STYLE("reset") } la { STYLE("bold", "yellow") }{ $repo_name }#{ $number }{ STYLE("reset") } li pona
msg-user-key-list-count = nimi SSH { $keys } li lon
msg-user-key-list-header = { STYLE("bold") }nimi SSH nanpa { STYLE("bright-magenta") }{ $id }{ STYLE("reset") }
msg-user-key-list-title = { STYLE("bold") }nimi lukin:{ STYLE("reset") }       { STYLE("bright-cyan") }{ $title }{ STYLE("reset") }
help-arg-repo = o ni lon poki seme
help-cmd-auth-login = o kama lon sijelo pi ma wan
help-cmd-auth-login-long =
    o kama lon sijelo pi ma wan

    lipu pi alasa ken li open lon ilo linluwi sina
help-cmd-auth-logout = o weka e sona ni: sijelo sina pi ma wan
help-cmd-auth-add_token = o pana e nimi len ilo pi ma wan
help-cmd-auth-add_token-long =
    o pana e nimi len ilo pi ma wan

    sina ken ala kepeken `forge auth login` la, o kepeken ni
help-arg-auth-add_token-token = o pana e nimi len ilo seme
help-cmd-auth-list = o lukin e sijelo sina ale
help-arg-actions-tasks-page = o lukin e kulupu alasa nanpa seme
help-cmd-actions-variables = o lawa e ijo sona ona
help-cmd-actions-variables-list = o lukin e ijo sona ona ale
help-arg-actions-variables-list-verbose = kin la, o lukin e ijo pi nimi 'owner_id' e ijo pi nimi 'repo_id'
help-cmd-actions-variables-create = o pana e ijo sona sin
help-arg-actions-variables-create-name = nimi ona o seme
help-arg-actions-variables-create-data = ona o poki e sona seme? sina pana ala e ni, ilo sina pi toki ante li open
help-arg-actions-variables-create-force = ijo sona ni li lon la o ante e ona
help-cmd-actions-variables-delete = o weka e ijo sona
help-arg-actions-variables-delete-name = o weka e ijo sona seme
help-cmd-actions-secrets = o lawa e ijo sona len
help-cmd-actions-secrets-list = o lukin e ijo sona len ona ale
help-cmd-actions-secrets-create = o pana e ijo sona len sin
help-arg-actions-secrets-create-name = nimi ona o seme
help-arg-actions-secrets-create-data = ona o poki e sona seme
help-cmd-actions-secrets-delete = o weka e ijo sona len
help-arg-actions-secrets-delete-name = o weka e ijo sona len seme
help-cmd-org-list = o lukin e kulupu ale
help-arg-org-list-page = o lukin e kulupu alasa nanpa seme
help-arg-org-list-only_member_of = o lukin e kulupu ni taso: sina lon ona
help-cmd-org-view = o lukin e kulupu
help-arg-org-view-name = o lukin e kulupu seme
help-arg-org-options-full_name = nimi lukin ona o seme
help-arg-org-options-full_name-long =
    nimi lukin ona o seme

    ken ala pi nimi `name` la nimi lukin li ni ala. ona li ken kepeken sitelen UTF-8 ale
help-arg-org-options-description = toki sona pi kulupu ni o seme
help-arg-org-options-email = nimi Email pi kulupu ni o seme
help-arg-org-options-location = kulupu li lon ma seme
help-arg-org-options-website = nimi pi lipu linluwi ona li seme
help-arg-org-options-visibility = seme li ken lukin e kulupu ni
help-arg-org-options-visibility-long =
    seme li ken lukin e kulupu ni

    'public' la ale li ken lukin e ona
    'limited' la jan pi ma ni taso li ken lukin e ona
    'private' la jan pi kulupu ni taso li ken lukin e ona
help-cmd-org-create = o open e kulupu sin
help-arg-org-create-name = nimi ona o seme
help-arg-org-create-name-long =
    nimi ona o seme

    ona li ken kepeken sitelen Lasina anu sitelen nanpa anu sitelen '-' anu sitelen '_' anu sitelen '.' taso
    sitelen open ona en sitelen pini ona o sitelen Lasina
    sitelen '-' anu sitelen '_' anu sitelen '.' li ken ala poka e sitelen sama

    ni la nimi wile sina li ken ala la, o kepeken nimi '--full-name'
help-cmd-org-edit = o ante e sona kulupu
help-arg-org-edit-name = o ante e sona pi kulupu seme
help-arg-org-edit-name-long =
    o ante e sona pi kulupu seme

    o pana e nimi ona, o pana ala e nimi lukin ona
help-cmd-org-activity = o lukin e pali kulupu
help-arg-org-activity-name = o lukin e pali pi kulupu seme
help-cmd-org-members = o lukin e jan kulupu
help-arg-org-members-org = o lukin e jan pi kulupu seme
help-arg-org-members-page = o lukin e kulupu alasa nanpa seme
help-cmd-org-visibility = o lukin anu ante e ni: seme li ken sona e ni: sina lon kulupu
help-arg-org-visibility-org = o ante e sona sina pi kulupu seme
help-arg-org-visibility-set = o ante e ni: seme li ken sona e ni: sina lon kulupu ni
help-cmd-org-label-list = o lukin e kule ale kulupu
help-arg-org-label-list-org = o lukin e kule pi kulupu seme
help-cmd-org-label-add = o open e kule sin lon kulupu
help-arg-org-label-add-org = o open e kule sin lon kulupu seme
help-arg-org-label-add-name = nimi pi kule sin o seme
help-arg-org-label-add-color = kule lukin pi kule sin o seme. o kepeken nasin 'Hexcode'
help-arg-org-label-add-description = toki sona pi kule sin o seme
help-arg-org-label-add-exclusive = nimi ona li sama { "'{nimi suli}/{nimi lili}'" } la o ni: kule wan taso pi nimi suli li ken lon toki
help-cmd-org-label-edit = o ante e kule kulupu
help-arg-org-label-edit-org = o ante e kule pi kulupu seme
help-arg-org-label-edit-name = o ante e kule seme
help-arg-remote = o kepeken poki Git weka seme
