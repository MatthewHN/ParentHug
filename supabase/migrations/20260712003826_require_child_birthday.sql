-- All existing child profiles have birthdays, so enforce the invariant at the
-- column level for every client and future write path.
alter table public.children
  alter column birthday set not null;
