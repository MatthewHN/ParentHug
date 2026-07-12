alter table public.children
  alter column temperament type text[]
  using (
    case
      when temperament is null or btrim(temperament) = '' then '{}'::text[]
      else array[temperament]
    end
  );

alter table public.children
  alter column temperament set default '{}';

alter table public.children
  alter column temperament set not null;;
