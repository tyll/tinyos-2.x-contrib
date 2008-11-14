SELECT hex(origin), count(DISTINCT udp_seqno) + max(udp_failed)  AS realsent, max(udp_seqno) AS sn, max(udp_failed), route_parent_hops AS hlim, route_parent_neighbor AS neighbor, max(ip_forwarded), max(ip_tx_drop) AS td, max(ip_fw_drop) AS fd, max(ip_rx_drop) AS rd, max(ip_real_drop) AS rd, max(ip_hlim_drop) AS hd, max(ip_senddone_el) AS el FROM lineMM WHERE 1 GROUP BY origin ORDER BY route_parent_hops,origin,ts;

SELECT origin, max(udp_failed)+count(DISTINCT udp_seqno),max(udp_seqno) FROM lineMM GROUP BY origin INTO OUTFILE '/tmp/histo'; 
