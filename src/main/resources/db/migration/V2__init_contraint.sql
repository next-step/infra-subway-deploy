alter table line add constraint UK_9ney9davbulf79nmn9vg6k7tn unique (name);
alter table station add constraint UK_gnneuc0peq2qi08yftdjhy7ok unique (name);
alter table section
       add constraint FKtecjgrtoxbeeqpymapva62xfw
       foreign key (down_station_id)
       references station (id);
alter table section
       add constraint FKlfhpg8lrvyr948juittt221ux
       foreign key (line_id)
       references line (id);
alter table section
       add constraint FK18bw17tb86fh1igov96s9i6he
       foreign key (up_station_id)
       references station (id);
